// SPDX-FileCopyrightText: 2023 Zextras <https://www.zextras.com>
//
// SPDX-License-Identifier: AGPL-3.0-only

library(
    identifier: 'jenkins-packages-build-library@1.0.3',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        remote: 'git@github.com:zextras/jenkins-packages-build-library.git',
        credentialsId: 'jenkins-integration-with-github-account'
    ])
)

pipeline {
  agent {
    node {
      label 'base'
    }
  }

  environment {
    NETWORK_OPTS = '--network ci_agent'
    FAILURE_EMAIL_RECIPIENTS='smokybeans@zextras.com'
  }

  options {
    skipDefaultCheckout()
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timeout(time: 1, unit: 'HOURS')
    parallelsAlwaysFailFast()
  }

  parameters {
    booleanParam defaultValue: false,
      description: 'Whether to upload the packages in playground repository',
      name: 'PLAYGROUND'
  }

  tools {
    jfrog 'jfrog-cli'
  }
  
  stages {
    stage('Build setup') {
      steps {
        checkout scm
        script {
          gitMetadata()
        }
      }
    }

    // stage('Stashing for packaging') {
    //   steps {
    //     stash includes: '**', name: 'project', useDefaultExcludes: false
    //   }
    // }

    stage('Build deb/rpm') {
      steps {
        echo 'Building deb/rpm packages'
        buildStage([
          rockySinglePkg: true,
          ubuntuSinglePkg: true,
        ])
      }
      post {
        failure {
          script {
            if ("main".equals(BRANCH_NAME) || "devel".equals(BRANCH_NAME)) {
              sendFailureEmail(STAGE_NAME)
            }
          }
        }
      }
    }

    stage('Upload artifacts') {
      steps {
        uploadStage(
          packages: yapHelper.getPackageNames(),
          rockySinglePkg: true,
          ubuntuSinglePkg: true,
        )
      }
      post {
        failure {
          script {
            if ("main".equals(BRANCH_NAME) || "devel".equals(BRANCH_NAME)) {
              sendFailureEmail(STAGE_NAME)
            }
          }
        }
      }
    }
  }
}

void sendFailureEmail(String step) {
  def commitInfo =sh(
     script: 'git log -1 --pretty=tformat:\'<ul><li>Revision: %H</li><li>Title: %s</li><li>Author: %ae</li></ul>\'',
     returnStdout: true
  )
  emailext body: """\
    <b>${step.capitalize()}</b> step has failed on trunk.<br /><br />
    Last commit info: <br />
    ${commitInfo}<br /><br />
    Check the failing build at the <a href=\"${BUILD_URL}\">following link</a><br />
  """,
  subject: "[WORKSTREAM COLLABORATION DB TRUNK FAILURE] Trunk ${step} step failure",
  to: FAILURE_EMAIL_RECIPIENTS
}
