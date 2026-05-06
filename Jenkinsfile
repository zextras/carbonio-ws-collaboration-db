// SPDX-FileCopyrightText: 2025 Zextras <https://www.zextras.com>
//
// SPDX-License-Identifier: AGPL-3.0-only

library(
    identifier: 'jenkins-dt3-lib@v1.2.0',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        remote: 'git@github.com:zextras/jenkins-dt3-lib.git',
        credentialsId: 'jenkins-integration-with-github-account'
    ])
)

library(
    identifier: 'jenkins-lib-common@1.7.2',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        credentialsId: 'jenkins-integration-with-github-account',
        remote: 'git@github.com:zextras/jenkins-lib-common.git',
    ])
)

properties(defaultPipelineProperties())

pipeline {
    agent {
        node {
            label 'zextras-v1'
        }
    }

    environment {
        LC_ALL = 'C.UTF-8'
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '25'))
        skipDefaultCheckout()
        timeout(time: 30, unit: 'MINUTES')
    }

    parameters {
        booleanParam(
            name: 'PREPARE_RELEASE',
            defaultValue: false,
            description: 'Check this to prepare a new release (creates pre-release branch and PR)'
        )
    }

    stages {
        stage('Setup') {
            steps {
                checkout scm
                script {
                    gitMetadata()
                }
            }
        }

        stage('Build container images') {
            steps {
                buildAndPublishDockerImage(
                        projectName: 'carbonio-ws-collaboration-db-sidecar',
                        dockerfile: 'docker/sidecar/Dockerfile',
                        imageTitle: 'Carbonio Ws Collaboration DB Sidecar',
                        imageDescription: 'Envoy Sidecar for Carbonio Ws Collaboration DB'
                )
            }
        }


        stage('Build deb/rpm') {
            steps {
                script {
                    buildPackages([
                        buildStageConfig: [
                            buildFlags: ' -ds ',
                        ]
                    ])
                }
            }
        }

        stage('Upload artifacts') {
            when {
                expression { return uploadStage.shouldUpload() }
            }
            tools {
                jfrog 'jfrog-cli'
            }
            steps {
                uploadStage(
                    packages: yapHelper.resolvePackageNames(),
                )
            }
        }

        stage('Prepare Release') {
            agent {
                node {
                    label 'sm-release-v1'
                }
            }
            when {
                allOf {
                    branch 'devel'
                    expression { params.PREPARE_RELEASE == true }
                    not {
                        expression {
                            return env.GIT_COMMIT_MSG.contains('[skip ci]') ||
                                   env.GIT_COMMIT_MSG.contains('chore(release):')
                        }
                    }
                }
            }
            steps {
                script {
                    container('nodejs-22') {
                        prepareRelease(
                            repoName: 'carbonio-ws-collaboration-db'
                        )
                    }
                }
            }
        }

        stage('Tag for release') {
            when {
                allOf {
                    branch 'devel'
                    expression {
                        return env.GIT_COMMIT_MSG.contains('chore(release):') &&
                               env.GIT_COMMIT_MSG.contains('[skip ci]')
                    }
                }
            }
            steps {
                script {
                    tagRelease()
                }
            }
        }
    }
}
