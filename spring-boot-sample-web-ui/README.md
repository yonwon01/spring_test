
### DevOps 실습하기

* 개발 환경 : 
   - OS : mac
   - 서버 : ibm private cloud 
   - editor : atom,eclipse

* spring-boot예제 이용 : [spring-boot-sample-web-ui)](https://github.com/spring-projects/spring-boot/tree/v2.0.2.RELEASE/spring-boot-samples/spring-boot-sample-web-ui) 

 1) gradle를 이용하여 build script 구성하기 

     1) mac에 gradle 설치하기
     ```
    brew install gradle
     ```
     2) build.gradle에 스크립트 작성하기
    
     3) 빌드하기
     
     ```
    gradle build
     ```
     4) 빌드하면 jar파일이 libs안에 생성
     ```
    cd build/libs/
     ```
        ![jar파일경로.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/Zu8AyfmQlaJbM68KengQ_jar%E1%84%91%E1%85%A1%E1%84%8B%E1%85%B5%E1%86%AF%E1%84%80%E1%85%A7%E1%86%BC%E1%84%85%E1%85%A9.png)
      5) 어플리케이션 실행
      ```
      java -jar [jar파일]
      ```
     
![java실행.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/GeNrXPDpRcCRiws1Xtp3_java%E1%84%89%E1%85%B5%E1%86%AF%E1%84%92%E1%85%A2%E1%86%BC.png)
     
2) 어플리케이션은 모두 컨테이너로 구성하기
    
     1) 어플리케이션을 컨테이너로 생성하기 위해 이미지파일(Dockerfile) 생성하기
       ![Dockerfile.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/JrDf1LAxRKqWNaCnfPC6_Dockerfile.png)

     2) Dockerfile 빌드하기
             ```
              docker build . -t yonwon01/spring_test
             ```
     3) docker regisrty hub으로 push 하기
            ```
              docker push yonwon01/spring_test:latest
            ```
     4) docker registry에 이미지 파일 올라온것 확인하기
       ![스크린샷 2019-04-06 오후 12.44.47.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/fFJGhP10QaeQ7zMQ2Lm4_%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202019-04-06%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%2012.44.47.png)

      5) kubernetes를 통해 컨테이너 실행시키기 : [쿠버네티스 설명)](https://github.com/yonwon01/TIL/tree/master/Kubernetes)
           -  spring-boot-sample-web-ui어플리케이션 이미지를 pod(쿠버네티스의 최소 실행단위),service 단위로 생성하기
           -  yaml 파일 : blue_deploy.yaml, svc.yaml
           -  파일 포맷은 yaml파일을 이용함
                   ```
                     kubectl creeate -f blue_deployment.yaml
                     kubectl create -f svc.yaml
                   ```  
           -  pod(container),svc가 생성된 것을 확인하기
                   ```
                     kubectl get pod
                     kubectl get svc
                   ```  

         ![message-get.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/1Wr6Pw53SmespCdUD67i_message-get.png)
           - docker container 확인하기
              ```
                 docker container ls
              ```  
         ![container-messages.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/y3CgMACbTAunEQxbJnvQ_container-messages.png)

3) 어플리케이션들의 Log 는 Host 에 file 로 적재
     1) spring-boot-sample-web-ui어플리케이션의 application.properties 에 logging 설정 하기
![스크린샷 2019-04-06 오후 4.45.15.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/pAg46WgTfK7JTLEtr91Q_%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202019-04-06%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%204.45.15.png)
      2)  웹어플리케이션을 뛰운 노드로 접속 -> 웹어플리케이션 컨테이너로 접속 -> log file 위치로 이동 후 확인
     
      ```
         ssh root@workernodeIP
         docker container exec -it 컨테이너id sh
         cd /var/message-service
         cat sample_app.log
      ```  
     ![logFile.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/mAAyLnNmR9rjuumjP2bw_logFile.png)


      
  4) container sacle in/out 하기
     1) kubecrnetes 의 replicaset을 통해 pod의 수를 증가 감소 시킨다
     ```
     kubectl scale deployment [deployment이름] --replicas [갯수]
     ```
     
![스크린샷 2019-04-06 오후 5.06.33.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/T7T6isOASfq63CeIsSI5_%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202019-04-06%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.06.33.png)
     
![스크린샷 2019-04-06 오후 5.06.39.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/sKlBzFMFRRepUevBAIr4_%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202019-04-06%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.06.39.png)

![스크린샷 2019-04-06 오후 5.06.47.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/j7WdaTQiRdua9Sp3pH7W_%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202019-04-06%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%205.06.47.png)

     
5) 웹서버 nginx 사용하기
     1) nginx:1.10-alpine 이미지를 pod(쿠버네티스의 최소 실행단위),service 단위로 생성하기
         - nginx 구성파일을 yaml로 작성
         - yaml 파일 : nginx-configfile.yaml, nginx.yaml, nginx-service.yaml
         - 웹서버는 Reverse proxy 80 port, Round robin 방식으로 설정 
         - nginx의 환경설정 (configuration file) 은 /etc/nginx/nginx.config 에서 가능하다 : kuberentes의 configmap으로 올리기위해 nginx-configmap.yaml에 구성했다
         - Nginx 에서 제공하는 Load Balancing method 는 3가지가 있는데 default가 라운드로빈방식 이다
         
      ```
         kubectl create -f nginx-configfile.yaml
         kubectl create -f nginx.yaml
         kubectl create -f nginx-service.yaml   
      ```  
     2) nginx 노드포트 확인 후 public IP:노드포트 로 웹브라우저 실행시키기
     
     ```
         kubectl get svc 
     ```  
![ngins-port.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/4khuhT3OT4yEyOW5SqLE_ngins-port.png)
      
![스크린샷 2019-04-07 오후 6.48.14.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/oSvYdpxHQn6KOcffTwFA_%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202019-04-07%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%206.48.14.png)
 
   
6) 무중단배포 - 블루그린 배포하기
     1) 배포되어있는 pod 갯수만큼 더 생성하여 기존버전에서 새 버전으로 배포할 수 있도록 한다.
      ```
     kubectl apply -f $DEPLOYMENTFILE
      ```
     2) green_deploy.yaml파일을 생성하여 기존의 blue_deploy.yaml에서 버전만 dev->opr로 변경하고 실행해본다.
      
     ```
       apiVersion: extensions/v1beta1
       kind: Deployment
       metadata:
         name: messages-opr
         labels:
           app: spring_message
       spec:
         strategy:
           type: Recreate
         replicas: 1
         minReadySeconds: 5
         template:
           metadata:
             labels:
               app: spring-message
               name: messages
               version : opr
           spec:
             containers:
               - image: yonwon01/spring_test:latest
                 imagePullPolicy: Always
                 name: messages-opr
                 ports:
                   - containerPort: 8082
     ```

     3) 무중단 배포 스크립트는 shell로 작성하였으며 실제 로드밸런싱이 되는 서비스 에서 selector의 version 이 dev->opr로 변경되도록 patch 한다.
     ```
     kubectl patch svc 서비스이름 -p '{"spec":{"selector":{"name":"messages","version":"opr"}}}'
     ```
     4) nginx의 80포트가 기존의 messages-dev 파드(blue포트(8081))에서 messages-opr 파드  (green(8082))으로 바라본다.
     
     5) 쉘 실행 (쉘의 설명은 bluegreen.sh 주석참고)
     ```
     sh ./bluegreen.sh messages-service opr deployment/green_deploy.yaml
     ```
![쉘실행.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/phwERl8RSkSBloAoOzXv_%E1%84%89%E1%85%B0%E1%86%AF%E1%84%89%E1%85%B5%E1%86%AF%E1%84%92%E1%85%A2%E1%86%BC.png)
     
![dev-opr변경.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/R0nmS6iaRx6YzzOWTE6Y_dev-opr%E1%84%87%E1%85%A7%E1%86%AB%E1%84%80%E1%85%A7%E1%86%BC.png)
     
7) 어플리케이션 REST API 추가 - GET /health] Health check 구현하기
     1)  Json Object 형태로 응답할 수 있도록 구현 - HashMap 사용(MessagesController.java)
![health구현.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/JrBRl3u9QaOY1ezeOpkj_health%E1%84%80%E1%85%AE%E1%84%92%E1%85%A7%E1%86%AB.png)
     2)  IP:PORT/health
   
![스크린샷 2019-04-07 오후 6.50.20.png](https://s3-ap-northeast-1.amazonaws.com/torchpad-production/wikis/10853/pzXAR6SmSNaDNHiu0kpt_%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA%202019-04-07%20%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE%206.50.20.png)
     
     
     
     
