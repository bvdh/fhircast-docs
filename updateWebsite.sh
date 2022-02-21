echo ====================================================
echo Push repo build
echo ====================================================
curl -X POST  "https://us-central1-fhir-org-starter-project.cloudfunctions.net/ig-commit-trigger"   -H "Content-type: application/json"   --data '{"ref": "refs/heads/Con29", "repository": {"full_name": "bvdh/fhircast-docs"}}'

export DOCKER_HOST=ssh://bvdh@212.187.34.124

echo ====================================================
echo build image
echo ====================================================
COMPOSE_DOCKER_CLI_BUILD=0 docker-compose up --build --detach fhircast-hub

echo ====================================================
echo run image
echo ====================================================
docker run -d -p 9400:80 fhircast-spec:latest


