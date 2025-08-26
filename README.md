# Ćwiczenie: Budowa własnego pipeline CI/CD z Jenkins i Docker

## Cel ćwiczenia

Celem zadania jest **samodzielne zbudowanie procesu CI/CD** w Jenkinsie, który:
- pobierze kod aplikacji z repozytorium,
- uruchomi testy jednostkowe,
- zbuduje obraz Dockerowy aplikacji,
- opublikuje obraz do wybranego registry,
- uruchomi kontener i wykona prosty smoke-test.

---

## Krok 1. Stworzenie Pipeline w Jenkinsie

1. Zaloguj się do swojej instancji Jenkinsa.
2. Utwórz **nowy projekt typu Pipeline** (lub Multibranch Pipeline, jeśli wiesz jak).
3. Skonfiguruj źródło SCM na repozytorium z kodem 
4. Jeśli tworzysz plik `Jenkinsfile` w repozytorium – przejdź do następnego kroku.
5. Alternatywnie, możesz wkleić kod pipeline bezpośrednio w ustawieniach projektu w polu „Pipeline script”.

---

## Krok 2. Napisz własny Jenkinsfile

Twoje zadania:

- Przygotuj deklaratywny `Jenkinsfile` realizujący etapy:
    - **Checkout** – pobranie kodu źródłowego z repozytorium,
    - **Test** – instalacja zależności (`pip install -r requirements.txt`) i uruchomienie testów (`pytest`),
    - **Build** – budowa obrazu Docker, oznaczonego tagiem opartym o hash commita,
    - **Push** – publikacja obrazu do Docker registry (np. Docker Hub),
    - **Deploy & Test** – uruchomienie kontenera oraz wykonanie testu zdrowia przez `curl http://localhost:5000/health`,
    - **Clean** – posprzątanie workspace (post always).

## Krok 4. Kryteria zaliczenia

- Pipeline uruchamia się bez błędów (status **zielony**).
- Obraz Docker pojawia się w Twoim rejestrze (Docker Hub lub innym), z tagiem opartym o hash commita.
- Etap testowy (pytest) przechodzi pozytywnie – nie ma błędów w testach.
- Smoke-test (`curl http://localhost:5000/health`) zwraca poprawny wynik JSON: `{"status": "ok"}`.
- **(Bonus)** W Jenkinsie pojawiają się artefakty raportów z testów (np. pliki HTML lub JUnit XML).


## Szkielet pipeline'u do wykorzystania

Mozesz uzyc ponizszego szkieletu do zlozenia pipeline'u badz pracowac samodzielnie

1. Stage checkout

```groovy

environment {
    repoUrl = "https://github.com/devopsit-mg/jenkins-training.git"
    githubCredentialsID = "github-access-mgworkshop"
}

stage("Checkout") {
    steps {
        git url: env.repoUrl, branch: "main", changelog: true, credentialsId: env.githubCredentialsID, poll: true
    }
```

2. Stage Test

```groovy

stage('Test') {
    steps {
        cd exercise-declarative-pipeline-ci-cd/app
        sh 'pip install -r requirements.txt'
        sh 'pytest -q'
    }
}

```

3. Stage Build oraz Push uzyj metody takiej jak w cwiczeniu z budowaniem obrazow

4. Deploy & smoke test

Aby zminimalizowac ryzyko uzycia tego samego portu na maszynie losujemy porty

```groovy

stage('Deploy & smoke-test') {
    steps {
        script {
            // Losujemy port z zakresu np. 10000-19999
            def random = new Random()
            env.APP_PORT = (10000 + random.nextInt(10000)).toString()
        }
        sh """
            CONTAINER_ID=\$(docker run -d -p \$APP_PORT:5000 ${IMAGE_TAG})
            sleep 3
            curl -f http://localhost:\$APP_PORT/health
            docker rm -f \$CONTAINER_ID
        """
    }
}

```