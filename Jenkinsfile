pipeline {
  parameters {
    string(name:'releasever', defaultValue:'31', description:'Fedora version')
    choice(name:'basearch', choices:['x86_64'], description:'Architecture')
    choice(name:'type', choices:['stable', 'unstable'], description:'Build type')
    choice(name:'channel', choices:['releases', 'nightly'], description:'Channel')
    choice(name:'product', choices:['lirios'], description:'Product to build')
    choice(name:'target', choices:['livecd'], description:'Target to build')
    string(name:'title', defaultValue:'Liri OS', description:'Image title')
  }
  agent {
    docker {
      image "liridev/ci-fedora-jenkins:latest"
      args '--privileged'
    }
  }
  environment {
      IMAGE_MANAGER_CREDENTIALS = credentials('image-manager')
  }
  stages {
    stage('Prepare') {
      steps {
        sh 'sudo dnf install -y git spin-kickstarts pykickstart livecd-tools gnupg2 pinentry'
        script {
          def now = new Date()
          today = now.format("yyyyMMdd", TimeZone.getTimeZone('Europe/Rome'))
          imageName = "${params.product}-${today}-${params.basearch}"
          isoFileName = "${imageName}.iso"
          checksumFileName = "${imageName}-CHECKSUM"
        }
        withCredentials([file(credentialsId: 'ci-pgp-key', variable: 'FILE')]) {
          sh label: 'Import PGP key', script: "gpg --import --no-tty --batch --yes ${FILE}"
        }
        echo "Building ${imageName}"
        sh "ksflatten --config=${params.product}-${params.target}.ks -o _jenkins.ks"
      }
    }
    stage('Create') {
      steps {
        sh label: 'Create image', script: "sudo livecd-creator --releasever='${params.releasever}' --config=_jenkins.ks --fslabel='${imageName}' --title='${params.title}' --product=lirios"
        sh label: 'Change permission', script: "sudo chmod o+r ${isoFileName} ${checksumFileName}"
        withCredentials([file(credentialsId: 'ci-pgp-passphrase', variable: 'FILE')]) {
          sh label: 'Checksum', script: "sha256sum -b --tag ${isoFileName} | gpg --clearsign --pinentry-mode=loopback --passphrase-file=${FILE} --no-tty --batch --yes > ${checksumFileName}"
        }
      }
    }
    stage('Publish') {
      steps {
        sh "sudo dnf install -y python3-requests python3-requests-toolbelt"
        sh "curl -O https://raw.githubusercontent.com/liri-infra/image-manager/develop/image-manager-client && chmod 755 image-manager-client"
        script {
          token = sh(returnStdout: true, script: "echo ${env.IMAGE_MANAGER_CREDENTIALS_PSW} | ./image-manager-client create-token --api-url=${env.IMAGE_MANAGER_URL} ${env.IMAGE_MANAGER_CREDENTIALS_USR}").trim()
        }
        sh "./image-manager-client upload --api-url=${env.IMAGE_MANAGER_URL} --token=${token} --channel=${params.channel} --image=${isoFileName} --checksum=${checksumFileName}"
        sh "sudo rm -f ${isoFileName} ${checksumFileName} image-manager-client _jenkins.ks"
      }
    }
  }
}
