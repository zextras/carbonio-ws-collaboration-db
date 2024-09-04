// SPDX-FileCopyrightText: 2023 Zextras <https://www.zextras.com>
//
// SPDX-License-Identifier: AGPL-3.0-only

pipeline {
  parameters {
    booleanParam defaultValue: false,
    description: 'Whether to upload the packages in playground repository',
    name: 'PLAYGROUND'
  }
  options {
    skipDefaultCheckout()
    buildDiscarder(logRotator(numToKeepStr: '5'))
    timeout(time: 1, unit: 'HOURS')
  }
  agent {
    node {
      label 'openjdk11-agent-v1'
    }
  }
  environment {
    NETWORK_OPTS = '--network ci_agent'
    FAILURE_EMAIL_RECIPIENTS='smokybeans@zextras.com'
  }
  stages {
    stage('Build setup') {
      steps {
        checkout scm
        script {
          env.GIT_COMMIT = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
        }
      }
    }
    stage('Stashing for packaging') {
      steps {
        stash includes: '**', name: 'project', useDefaultExcludes: false
      }
    }
    stage('Building packages') {
      parallel {
        stage('Ubuntu') {
          agent {
            node {
              label 'yap-agent-ubuntu-20.04-v2'
            }
          }
          steps {
            unstash 'project'
            script {
              if (BRANCH_NAME == 'devel') {
                def timestamp = new Date().format('yyyyMMddHHmmss')
                sh "sudo yap build ubuntu . -r ${timestamp}"
              } else {
                sh 'sudo yap build ubuntu .'
              }
            }
            stash includes: 'artifacts/', name: 'artifacts-ubuntu'
          }
          post {
            failure {
              script {
                if ("main".equals(BRANCH_NAME) || "devel".equals(BRANCH_NAME)) {
                  sendFailureEmail(STAGE_NAME)
                }
              }
            }
            always {
              archiveArtifacts artifacts: 'artifacts/*.deb', fingerprint: true
            }
          }
        }
        stage('RHEL') {
          agent {
            node {
              label 'yap-agent-rocky-8-v2'
            }
          }
          steps {
            unstash 'project'
            script {
              if (BRANCH_NAME == 'devel') {
                def timestamp = new Date().format('yyyyMMddHHmmss')
                sh "sudo yap build rocky . -r ${timestamp}"
              } else {
                sh 'sudo yap build rocky .'
              }
            }
            stash includes: 'artifacts/x86_64/*.rpm', name: 'artifacts-rocky'
          }
          post {
            failure {
              script {
                if ("main".equals(BRANCH_NAME) || "devel".equals(BRANCH_NAME)) {
                  sendFailureEmail(STAGE_NAME)
                }
              }
            }
            always {
              archiveArtifacts artifacts: 'artifacts/x86_64/*.rpm', fingerprint: true
            }
          }
        }
      }
    }
    stage('Upload To Playground') {
      when {
        expression { params.PLAYGROUND == true }
      }
      steps {
        unstash 'artifacts-ubuntu'
        unstash 'artifacts-rocky'

        script {
          def server = Artifactory.server 'zextras-artifactory'
          def buildInfo
          def uploadSpec
          buildInfo = Artifactory.newBuildInfo()
          uploadSpec = """{
            "files": [
              {
                "pattern": "artifacts/*.deb",
                "target": "ubuntu-playground/pool/",
                "props": "deb.distribution=focal;deb.distribution=jammy;deb.distribution=noble;deb.component=main;deb.architecture=amd64;vcs.revision=${env.GIT_COMMIT}"
              },
              {
                "pattern": "artifacts/x86_64/(carbonio-ws-collaboration-db)-(*).rpm",
                "target": "centos8-playground/zextras/{1}/{1}-{2}.rpm",
                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras;vcs.revision=${env.GIT_COMMIT}"
              },
              {
                "pattern": "artifacts/x86_64/(carbonio-ws-collaboration-db)-(*).rpm",
                "target": "rhel9-playground/zextras/{1}/{1}-{2}.rpm",
                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras;vcs.revision=${env.GIT_COMMIT}"
              }
            ]
          }"""
          server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
        }
      }
    }
    stage('Upload To Devel') {
      when {
        branch 'devel'
      }
      steps {
        unstash 'artifacts-ubuntu'
        unstash 'artifacts-rocky'

        script {
          def server = Artifactory.server 'zextras-artifactory'
          def buildInfo
          def uploadSpec
          buildInfo = Artifactory.newBuildInfo()
          uploadSpec = """{
            "files": [
              {
                "pattern": "artifacts/*.deb",
                "target": "ubuntu-devel/pool/",
                "props": "deb.distribution=focal;deb.distribution=jammy;deb.distribution=noble;deb.component=main;deb.architecture=amd64;vcs.revision=${env.GIT_COMMIT}"
              },
              {
                "pattern": "artifacts/x86_64/(carbonio-ws-collaboration-db)-(*).rpm",
                "target": "centos8-devel/zextras/{1}/{1}-{2}.rpm",
                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras;vcs.revision=${env.GIT_COMMIT}"
              },
              {
                "pattern": "artifacts/x86_64/(carbonio-ws-collaboration-db)-(*).rpm",
                "target": "rhel9-devel/zextras/{1}/{1}-{2}.rpm",
                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras;vcs.revision=${env.GIT_COMMIT}"
              }
            ]
          }"""
          server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
        }
      }
      post {
        failure {
          script {
            sendFailureEmail(STAGE_NAME)
          }
        }
      }
    }
    stage('Upload & Promotion Config') {
      when {
        buildingTag()
      }
      steps {
        unstash 'artifacts-ubuntu'
        unstash 'artifacts-rocky'

        script {
          def server = Artifactory.server 'zextras-artifactory'
          def buildInfo
          def uploadSpec
          def config

          //ubuntu
          buildInfo = Artifactory.newBuildInfo()
          buildInfo.name += '-ubuntu'
          uploadSpec = """{
            "files": [
              {
                "pattern": "artifacts/*.deb",
                "target": "ubuntu-rc/pool/",
                "props": "deb.distribution=focal;deb.distribution=jammy;deb.distribution=noble;deb.component=main;deb.architecture=amd64;vcs.revision=${env.GIT_COMMIT}"
              }
            ]
          }"""
          server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
          config = [
             'buildName'          : buildInfo.name,
             'buildNumber'        : buildInfo.number,
             'sourceRepo'         : 'ubuntu-rc',
             'targetRepo'         : 'ubuntu-release',
             'comment'            : 'Do not change anything! Just press the button',
             'status'             : 'Released',
             'includeDependencies': false,
             'copy'               : true,
             'failFast'           : true
          ]
          Artifactory.addInteractivePromotion server: server,
          promotionConfig: config,
          displayName: 'Ubuntu Promotion to Release'
          server.publishBuildInfo buildInfo

          //rhel8
          buildInfo = Artifactory.newBuildInfo()
          buildInfo.name += "-centos8"
          uploadSpec = """{
            "files": [
              {
                "pattern": "artifacts/x86_64/(carbonio-ws-collaboration-db)-(*).rpm",
                "target": "centos8-rc/zextras/{1}/{1}-{2}.rpm",
                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras;vcs.revision=${env.GIT_COMMIT}"
              }
            ]
          }"""
          server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
          config = [
             'buildName'          : buildInfo.name,
             'buildNumber'        : buildInfo.number,
             'sourceRepo'         : 'centos8-rc',
             'targetRepo'         : 'centos8-rc',
             'comment'            : 'Do not change anything! Just press the button',
             'status'             : 'Released',
             'includeDependencies': false,
             'copy'               : true,
             'failFast'           : true
          ]
          Artifactory.addInteractivePromotion server: server,
          promotionConfig: config,
          displayName: 'RHEL8 Promotion to Release'
          server.publishBuildInfo buildInfo

          //rhel9
          buildInfo = Artifactory.newBuildInfo()
          buildInfo.name += "-rhel9"
          uploadSpec = """{
            "files": [
              {
                "pattern": "artifacts/x86_64/(carbonio-ws-collaboration-db)-(*).rpm",
                "target": "rhel9-rc/zextras/{1}/{1}-{2}.rpm",
                "props": "rpm.metadata.arch=x86_64;rpm.metadata.vendor=zextras;vcs.revision=${env.GIT_COMMIT}"
              }
            ]
          }"""
          server.upload spec: uploadSpec, buildInfo: buildInfo, failNoOp: false
          config = [
             'buildName'          : buildInfo.name,
             'buildNumber'        : buildInfo.number,
             'sourceRepo'         : 'rhel9-rc',
             'targetRepo'         : 'rhel9-rc',
             'comment'            : 'Do not change anything! Just press the button',
             'status'             : 'Released',
             'includeDependencies': false,
             'copy'               : true,
             'failFast'           : true
          ]
          Artifactory.addInteractivePromotion server: server,
          promotionConfig: config,
          displayName: 'RHEL9 Promotion to Release'
          server.publishBuildInfo buildInfo
        }
      }
      post {
        failure {
          script {
            sendFailureEmail(STAGE_NAME)
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
