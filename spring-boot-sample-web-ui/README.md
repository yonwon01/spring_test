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
   
6) 무중단배포
     
     
     
     
