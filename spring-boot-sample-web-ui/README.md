### DevOps 실습하기

* 개발 환경 : mac, 클라우드 master node

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
    ![jar파일!]()
    
    5) 어플리케이션 실행
     ```
    java -jar [jar파일]
     ```
     ![어플리케이션_실행화면!]()

2) 어플리케이션은 모두 컨테이너로 구성하기
    1) 어플리케이션을 컨테이너로 생성하기 위해 이미지파일(Dockerfile) 생성하기
    ![Dockerfile!]()
    2) Dockerfile 빌드하기
      ```
       docker build . -t yonwon01/spring_test
      ```
    3) docker regisrty hub으로 push 하기
     ```
       docker push yonwon01/spring_test:latest
     ```
    4) docker registry에 이미지 파일 올라온것 확인하기
    ![dockerRegisry]()
    
    5) kubernetes를 통해 컨테이너 실행시키기 : [쿠버네티스 설명)]()
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
       - docker container 확인하기
       ```
          docker container ls
       ```  
3) 어플리케이션들의 Log 는 Host 에 file 로 적재
     1) spring-boot-sample-web-ui어플리케이션의 application.properties 에 logging 설정 하기
     2)  웹어플리케이션을 뛰운 노드로 접속 -> 웹어플리케이션 컨테이너로 접속 -> log file 위치로 이동 후 확인
     
      ```
         ssh root@workernodeIP
         docker container exec -it 컨테이너id sh
         cd /var/message-service
         cat sample_app.log
      ```  
      
4) container sacle in/out 하기
     1) kubecrnetes 의 replicaset을 통해 pod의 수를 증가 감소 시킨다
     ```
     kubectl scale deployment [deployment이름] --replicas [갯수]
     ```
     ![sacle_out]()
     ![sacle_in]()
     
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
      ![svc]()
      ![화면보여주기 ]()
   
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
     
6) 어플리케이션 REST API 추가 - GET /health] Health check 구현하기
     1)  Json Object 형태로 응답할 수 있도록 구현 - HashMap 사용(MessagesController.java)
     ![ health구현]()
     2)  IP:PORT/health
     ![health ]()
     
     
     
     
