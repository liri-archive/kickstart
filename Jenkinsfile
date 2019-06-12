pipeline {
  parameters {
    string(name:'releasever', defaultValue:'30', description:'Fedora version')
    choice(name:'basearch', choices:['x86_64'], description:'Architecture')
    choice(name:'type', choices:['stable', 'unstable'], description:'Build type')
    choice(name:'channel', choices:['releases', 'nightly'], description:'Channel')
    choice(name:'product', choices:['lirios'], description:'Product to build')
    choice(name:'target', choices:['livecd'], description:'Target to build')
    string(name:'title', defaultValue:'Liri OS', description:'Image title')
  }
  agent {
    docker {
      image "fedora:${params.releasever}"
      args '--privileged --user root'
    }
  }
  environment {
      IMAGE_MANAGER_CREDENTIALS = credentials('image-manager')
  }
  stages {
    stage('Prepare') {
      steps {
        sh 'dnf install -y git spin-kickstarts pykickstart livecd-tools'
        script {
          def now = new Date()
          today = now.format("yyyyMMdd", TimeZone.getTimeZone('Europe/Rome'))
          imageName = "${params.product}-${today}-${params.basearch}"
          isoFileName = "${imageName}.iso"
          checksumFileName = "${imageName}-CHECKSUM"
        }
        echo "Building ${imageName}"
        sh "ksflatten --config=${params.product}-${params.target}.ks -o _jenkins.ks"
      }
    }
    stage('Create') {
      steps {
        sh "livecd-creator --releasever='${params.releasever}' --config=_jenkins.ks --fslabel='${imageName}' --title='${params.title}' --product=lirios"
        sh "sha256sum -b --tag ${isoFileName} > ${checksumFileName}"
      }
    }
    stage('Publish') {
      steps {
        sh "dnf install -y python3-requests python3-requests-toolbelt"
        sh "curl -O https://raw.githubusercontent.com/liri-infra/image-manager/develop/image-manager-client && chmod 755 image-manager-client"
        script {
          token = sh(returnStdout: true, script: "echo ${env.IMAGE_MANAGER_CREDENTIALS_PSW} | ./image-manager-client create-token --api-url=${env.IMAGE_MANAGER_URL} ${env.IMAGE_MANAGER_CREDENTIALS_USR}").trim()
        }
        sh "./image-manager-client upload --api-url=${env.IMAGE_MANAGER_URL} --token=${token} --channel=${params.channel} --image=${isoFileName} --checksum=${checksumFileName}"
        sh "rm -f ${isoFileName} ${checksumFileName} image-manager-client _jenkins.ks"
      }
    }
  }
}
