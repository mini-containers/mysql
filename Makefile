build: Dockerfile
	docker build -t mini-mysql .

tag:
	docker tag mini-mysql mini/mysql
