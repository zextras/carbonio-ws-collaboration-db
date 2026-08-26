// SPDX-FileCopyrightText: 2025 Zextras <https://www.zextras.com>
//
// SPDX-License-Identifier: AGPL-3.0-only

library(
    identifier: 'jenkins-lib-common@v4.9.2',
    retriever: modernSCM([
        $class: 'GitSCMSource',
        credentialsId: 'jenkins-integration-with-github-account',
        remote: 'git@github.com:zextras/jenkins-lib-common.git',
    ])
)

dt3_pipeline(
    repoName: 'carbonio-ws-collaboration-db',
    packaging: [
        buildFlags: '-ds',
        rockySinglePkg: false,
        ubuntuSinglePkg: false,
    ],
    docker: [[
        dockerfile: 'docker/sidecar/Dockerfile',
        imageName: 'carbonio-ws-collaboration-db-sidecar',
        platforms: ['linux/amd64', 'linux/arm64'] as Set,
        title: 'Carbonio Ws Collaboration DB Sidecar',
        description: 'Envoy Sidecar for Carbonio Ws Collaboration DB',
    ]],
    reuse: [projectType: 'CE'],
)
