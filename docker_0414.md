# Docker 기초 실습 정리 (VSCode Markdown 형식)

---

## ✅ 도커 버전 확인
```bash
$ sudo docker version
```

---

## 📚 이번 주 수업 핵심 내용 요약
- 도커 기본 명령어 실습
- 다양한 컨테이너 실습 (Python, Ruby, Django 등)
- Docker 네트워크 & 볼륨 이해
- Dockerfile 작성 및 이미지 빌드
- Docker Compose 사용법

---

## 🐳 컨테이너 실행 실습

### 1. HelloWorld 이미지로 컨테이너 실행
```bash
docker container run hello-world
```
- 도커 설치 및 실행 테스트용 이미지
- 컨테이너 생성 → 실행 → 종료 과정 확인

### 2. Ubuntu 컨테이너 실행 (대화형)
```bash
docker container run -it ubuntu bash
```
- `-it` : 대화형 모드 (interactive + tty)
- Ubuntu 컨테이너 안으로 들어감

### 3. Ruby 컨테이너 실행 예시
```bash
docker container run --rm ruby ruby -e "print 40 + 2"
```

### 4. Python 컨테이너 대화형 실행
```bash
docker container run --rm -it python:3.11.6 python3
```
- 모든 아래 명령은 같은 효과:
```bash
docker container run --rm --interactive --tty python:3.11.6 python3
docker container run --rm -ti python:3.11.6 python3
docker container run --rm -i -t python:3.11.6 python3
```

### 5. 컨테이너 이름 붙이기
```bash
docker container run --name hello_seo hello-world
```

### 6. 컨테이너 자동 삭제 옵션
```bash
docker container run --rm [이미지명]
docker container run --name hello_seo2 --rm hello-world
```

---

## 🧼 컨테이너 관리 명령어

### 컨테이너 상태 확인
```bash
sudo docker container ls --all
```

### 컨테이너 삭제
```bash
sudo docker container rm [컨테이너 ID 또는 이름]
sudo docker container prune  # 전체 삭제
```

### 가동 중인 컨테이너 내부 명령 실행
```bash
docker container exec -it [컨테이너명] bash
docker container exec mydb head -n 4 /etc/os-release
```

---

## 🌐 Nginx 컨테이너 실행 (웹 서버)
```bash
docker container run --rm --publish 8080:80 nginx
```
- 포트 포워딩: `호스트포트:컨테이너포트`
- 8080 → 내 PC 브라우저에서 확인 가능

### Nginx 장점
- 가벼운 웹 서버
- 로드 밸런싱 기능
- 비동기 이벤트 기반 (성능 우수)
- **동기 vs 비동기**
  - 동기: 요청마다 순차 처리 (직렬)

---

## ⚙️ 환경 변수 설정 (DB 컨테이너 예시)
```bash
docker container run --name some-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -d mysql
```
- `--env` 또는 `-e`: 환경변수 설정
- DB 컨테이너 실행 시 자주 사용됨

---

## 📦 도커 이미지 관련 명령어

### 1. 이미지 목록 & 상세 확인
```bash
docker image ls
docker image inspect [이미지명]
```

### 2. 이미지 삭제 및 정리
```bash
docker image rm [이미지명 또는 ID]
docker image prune       # Dangling 이미지 삭제
docker image prune -a    # 사용 안 하는 모든 이미지 삭제 (주의!)
```

### 3. 이미지 생성 & 태깅
```bash
docker build -t [이미지명:태그] .
docker tag [원본이미지] [새이름:태그]
```

### 4. 이미지 가져오기/올리기
```bash
docker pull [이미지명:태그]
docker push [이미지명:태그]  # docker login 필요
```

### 5. 이미지 히스토리 확인
```bash
docker image history [이미지명]
```

### 6. 이미지 백업 & 복원
```bash
docker save -o [파일명.tar] [이미지명]
docker load -i [파일명.tar]
docker import [파일명.tar]
```

### 7. Ubuntu / Ruby 이미지 실습 예시
```bash
docker image pull ubuntu:23.10
docker image pull ruby:3.2.2
docker image inspect ruby:3.2.2
docker container run --rm ruby:3.2.2 printenv RUBY_VERSION
```

---

## 🧱 도커 이미지 구조 (레이어 & 메타데이터)
- 도커 이미지는 여러 개의 **레이어**로 구성됨
- 예: 우분투 + 파이썬 + MySQL
- 각 이미지에는 **메타데이터**가 포함됨
  - 기본 명령어 (CMD 등)
  - 환경변수 (ENV 등)

```text
[HOST[:PORT]/][NAMESPACE/]REPOSITORY[:TAG]
docker.io/library/ubuntu:23.10
```
- TAG 생략 시 `latest`가 기본값 → 재현성 이슈 발생 가능

# 도커 이미지
# 컨테이너 이미지화
- 우분투 컨테이너를 가동, vi명령어 설치
- '-it' : --interactive, --tty
- docker 명령어 : docker container commit 컨테이너명 your_repo_name:tag

```bash
docker container run --name myubuntu -it ubuntu:22.04 bash
which vi # 안나옴
apt update && apt install vim -y
which vi # 설치해서 이제는 나옴
docker container run --rm ubuntu:22.04 which vi
docker container commit myubuntu vi2-ubuntu:commit
```
- 도커 허브로 업로드
```bash
docker login -u [ID]
docker tag vi2-ubuntu:commit seojung/vi2-ubuntu:1.1
docker push seojung/vi2-ubuntu:1.1
```

# Docker | 우부투 컨테이너 이미지화 & Docker Hub 업로드

도커 환경에서 **기본 우부투 이미지에 vi(vim)을 설치**한 후, 해당 상태를 새로운 이미지로 커미팅하고, **Docker Hub에 업로드**하는 과정입니다.

---

## 우부투 컨테이너 가드 및 `vim` 설치

```bash
docker container run --name myubuntu -it ubuntu:22.04 bash
```

- `--name myubuntu` : 컨테이너 이름 설정
- `-it` : `--interactive` + `--tty` 옵션, 터미널 인터랙션 가능
- `ubuntu:22.04` : 배이스 이미지
- `bash` : 실행할 명령어

```bash
which vi
```

- `vi` 명령어 경로 확인  
- 기본 우부투에는 `vi`가 없기 때문에 아무것도 출력되지 않음

```bash
apt update && apt install vim -y
```

- 패키지 목록 업데이트 후 `vim` 설치  
- `-y` 옵션으로 설치 시 자동으로 yes 처리

```bash
which vi
```

- `/usr/bin/vi`와 같이 경로가 출력되면 설치 완료

---

## 변경된 컨테이너 상태를 이미지로 저장 (Commit)

```bash
docker container commit myubuntu vi2-ubuntu:commit
```

- `myubuntu` : 변경한 컨테이너 이름
- `vi2-ubuntu:commit` : 새 이미지 이름과 태그 설정

이제 `vim`이 설치된 컨테이너 이미지가 생성됨.

---

## 컨테이너 이미지 확인

```bash
docker container run --rm vi2-ubuntu:commit which vi
```

- `--rm` : 컨테이너 실행 종료 시 자동 삭제
- `which vi` 실행 결과가 나오면 이미지에 `vim`이 포함된 것 확인 가능

---

## Docker Hub로 업로드하기

```bash
docker login -u [ID]
```

- Docker Hub에 로그인 (ID과 비밀번호 입력)

```bash
docker tag vi2-ubuntu:commit seojung/vi2-ubuntu:1.1
```

- `docker tag` : 기존 이미지에 Docker Hub 업로드용 이름과 태그 부여  
  (`[DockerHub ID]/[이미지명]:[태그]` 형태)

```bash
docker push seojung/vi2-ubuntu:1.1
```

- Docker Hub에 컨테이너 이미지 업로드

> 업로드 완료 후 Docker Hub-> My Hub에서 확인가능

# 도커 이미지 삭제
```bash
docker image rm -f [IMAGE ID]
```

# 도커 이미지 다운로드
```bash
docker container run --rm -it seojung/vi-ubuntu:1.0 bash
```

# 도커 이미지 지울 때 주의점
- 이미지와 물려 있는 컨테이너가 있으면, 삭제 어려움
- 컨테이너를 먼저 선 삭제
- 해당되는 이미지를 지우기

# 개인이 만든 도커 이미지를 Dockerhub로 등록 (Online)
- 도커 이미지를 tar파일로 내보내기기
- 오늘은 컨테이너를 생성하고 생성된 컨테이너를 이미지화 하는 수업

# 도커 이미지를 tar로 이미지화 하기

## 1. 컨테이너를 `.tar` 파일로 내보내기 (Export)

```bash
docker container export -o vi-ubuntu.tar myubuntu
```

- `-o` 옵션: 출력 파일명을 지정 (예: `vi-ubuntu.tar`)
- `myubuntu`: 내보낼 컨테이너 이름

## 2. `.tar` 파일 존재 여부 확인

```bash
ls
```

```bash
seo@seo-VirtualBox:~/Desktop/ubuntu-server$ ls
deploy.sh  docker_0414.md  --env  ex.txt  mysql  --name  --publsih  README.md  test.sh  vi-ubuntu.tar
```

## 3. `.tar` 파일을 USB 등 저장장치에 복사 → 다른 PC로 이동

- `cp vi-ubuntu.tar /media/usb` 또는 GUI로 드래그해서 복사

## 4. 다른 PC에서 도커 이미지로 불러오기 (Import)

```bash
docker image import vi-ubuntu.tar vi-ubuntu:import
```

- `vi-ubuntu.tar`: 가져올 파일명
- `vi-ubuntu:import`: 새 이미지 이름과 태그 지정

## 5. 불러온 이미지 확인

```bash
docker image ls
```

---

### (선택) 불러온 이미지로 컨테이너 실행 예시

```bash
docker container run --name from-tar -it vi-ubuntu:import


# 이미지 tar로 만들고 다시 이미지화
- 명령어 : docker image save (저장하기)
  + 여러 이미지들을 저장하는 컨셉, 기술적 난이도 : medium
  
- 명령어 : docker image load (불러오기)