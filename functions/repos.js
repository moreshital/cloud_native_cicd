module.exports = {
    'cloud-native-cicd': {
        'name': 'cloud-native-cicd',
        'channel': 'cloud-native-cicd',
        'deploymentSourceBranch': 'master',
        'productionCandidateBranch': 'production-candidate',
        'repoLink': 'https://github.com/moreshital/cloud-native-cicd',
        'productionTriggerId': 'wids-cnci-production-deploy-trigger',
        'stagingEnvUrl': 'http://34.120.42.4/',
        'productionEnvUrl': 'http://34.120.63.180/',
        'gcrImageId': 'wids-app-image'
    }
}
