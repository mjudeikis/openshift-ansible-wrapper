#!groovy
def playbook_dir = "playbooks"
def inventory_dir = "inventory"

node('localhost') {
    stage('Initial setup') {
        deleteDir()
        checkout scm

        def playbooks = []
        dir(playbook_dir) {
            def files = findFiles(glob: '*.yml')
            for (def file : files) {
                playbooks.add(file.path.replace('.yml',''))
            }
        }

        def environments = []
        dir(inventory_dir) {
            def files = findFiles(glob: '*')
            for (def file : files) {
                environments.add(file.path)
            }
        }
        properties([
            parameters([
                choice(
                    name: 'ENVIRONMENT',
                    description: 'On which Environment we want to run pipeline',
                    choices: environments.join("\n"),
                ),
                choice(
                    name: 'PLAYBOOK',
                    description: 'Playbook to run',
                    choices: playbooks.join("\n"),
                ),
                string(
                    name: 'TAGS',
                    description: 'Tags to be run. Empty = all'
                ),
                string(
                    name: 'ARGS',
                    description: 'Extra arguments for the playbook. E.g. "-v" for verbose output'
                    ),
                    [
                        $class: 'GitParameterDefinition',
                        branch: '',
                        branchFilter: '.*',
                        defaultValue: 'origin/master',
                        description: 'Branch to run',
                        name: 'BRANCH',
                        quickFilterEnabled: false,
                        selectedValue: 'DEFAULT',
                        sortMode: 'NONE',
                        tagFilter: '*',
                        type: 'PT_BRANCH'
                    ]
            ])
        ])
    }

    stage('Checkout branch') {
        /* Checkout the repository again with a different branch name */
        git(
            branch: BRANCH.split('/')[1],
            url: 'https://github.com/mjudeikis/ocp-ansible-wrapper.git'
        )
        dir('openshift-ansible') {
            git(
                branch: "release-3.7",
                url: 'https://github.com/openshift/openshift-ansible.git'
            )
        }
    }

    stage('Install galaxy roles') {
        sh ("ansible-galaxy install -r roles/requirements.yml")
    }

    stage('Execute playbook') {

        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'ad-join', passwordVariable: 'VAULT_PWD', usernameVariable: ''],
                         [$class: 'FileBinding', credentialsId: 'ansible_id_rsa', variable: 'ANSIBLE_ID_RSA']]) {

            cmd = "ansible-playbook -i ${inventory_dir}/$ENVIRONMENT ${playbook_dir}/${PLAYBOOK}.yml --private-key \${ANSIBLE_ID_RSA}"
            if (ARGS != '') {
                cmd += " \"${ARGS}\""
            }
            if (TAGS != '') {
                cmd += " --tags '${TAGS}' "
            }
            /* yum-yum shiny colours */
            wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm']) {
                withEnv(['ANSIBLE_FORCE_COLOR=true']) {
                    sh(cmd)
                }
            }
        }
    }
}
