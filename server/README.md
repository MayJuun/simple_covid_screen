# njck

## Docker
- Ensure docker is installed, to check run:  
```$ docker run hello-world```
- Build it:  
```$ docker build -t projectName .```
- Test it:  
```$ docker run -d -p 8080:8080 projectName```
- Get Google Cloud account
- Create Project
- Note Project ID
- Enable Container Registry
- Initialize gcloud  
```$ gcloud init```
- Configure docker for gcloud  
```$ gcloud auth configure-docker```
- Build container in Google Cloud Container Registry  
```$ docker build -t gcr.io/projectId/projectName:version .```  
For the above, the projectId is your GCP project ID, the projectName is the name of the docker file that we had above, and the version is however you want to define versions in the cloud so in the future you'll know which is which. For instance, if our GCP project Id is ```new-project-123456``` our docker project was called ```docker-project```, we would write:  
```$ docker build -t gcr.io/new-project-123456/docker-project:v0.1 .```
- Push container to cloud
```$ docker push gcr.io/projectId/projectNam:version```
