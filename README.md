[![lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)

# Neotoma Application Stack

This Docker Compose application is designed to mimic the full Neotoma Stack, including a clean version of the Neotoma Database (all personal data has been anonymized). We combine a "clean" version of the Neotoma database, with both the Tilia and Neotoma APIs.

The stack downloads the "clean" tar file from our repository, and installs it into the container, and then pulls in both the apis from Github, building them with Node/yarn.  Once the container is deployed the following ports will be active:

* 5435: Neotoma Postgres Database
* 3001: Neotoma API
* 3006: Tilia API

## Contributors

* [Simon Goring](http://goring.org): University of Wisconsin - Madison [![orcid](https://img.shields.io/badge/orcid-0000--0002--2700--4605-brightgreen.svg)](https://orcid.org/0000-0002-2700-4605)
* Socorro Dominguez

## Contribution

We welcome user contributions to this project.  All contributors are expected to follow the [code of conduct](code_of_conduct.md).  Contributors should fork this project and make a pull request indicating the nature of the changes and the intended utility.  Further information for this workflow can be found on the GitHub [Pull Request Tutorial webpage](https://help.github.com/articles/about-pull-requests/).

## Using This Repository

To use this repository, first clone the repository to your local computer:

```bash
git clone 
```

Once the 