# Changelog

## [1.1.0](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/compare/ansible-v1.0.3...ansible-v1.1.0) (2023-05-17)


### Features

* **ansible:** add conftest binary ([#134](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/134)) ([71c6837](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/71c68377f22872ae19b068b2eaadd0e2e5951620))


### Miscellaneous Chores

* fix URLs in changelogs ([ce68209](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/ce6820972fb82bdaec93036588fc28896bf8ea63))

## [1.0.3](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/compare/ansible-v1.0.2...ansible-v1.0.3) (2023-05-16)


### Miscellaneous Chores

* **deps:** update dependency ansible-lint to ~=6.16.0 (ansible) ([#120](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/120)) ([615cf71](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/615cf715ebf9ba25267c6d0ca592040b79475e2d))
* **deps:** update dependency databus23/helm-diff to v3.8.0 (ansible) ([#127](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/127)) ([0d33d9e](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/0d33d9e479400775c3402bd3eee34537177f0795))
* **deps:** update dependency docker to ~=6.1.2 (ansible) ([#118](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/118)) ([bf03a43](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/bf03a438c85971979d9dd7c0f54d721ebad23181))

## [1.0.2](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/compare/ansible-v1.0.1...ansible-v1.0.2) (2023-05-15)


### Miscellaneous Chores

* **deps:** update alpine/helm docker tag to v3.12.0 (ansible) ([#123](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/123)) ([01a83bd](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/01a83bd58e8292c0e59c0eb270ee41abf3727d7e))
* **deps:** update dependency bitnami-labs/sealed-secrets to v0.21.0 (ansible) ([#125](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/125)) ([a5100de](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/a5100de31e8b76724e96937625ea71c8d2b64405))

## [1.0.1](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/compare/ansible-v1.0.0...ansible-v1.0.1) (2023-04-28)


### Miscellaneous Chores

* **deps:** update dependency ansible to ~=7.5.0 (ansible) ([#108](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/108)) ([26341ce](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/26341ce196fc79182ebecf443b9fb874af042e66))
* **deps:** update dependency rancher/rke to v1.3.20 (ansible) ([#113](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/113)) ([664f505](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/664f5051ad19fe84f852e8443dcda98322afc322))

## 1.0.0 (2023-04-26)


### Features

* add github action runner images ([#73](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/73)) ([a410c17](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/a410c17d2974910e76fc329828a4a0963cfa3fab))


### Bug Fixes

* **ansible:** install `openssh-client` ([82750e0](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/82750e0da509a47d09cd7cc1c81c18605166b2b9))
* use non-root user in ansible image ([#83](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/83)) ([1e7c7e4](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/1e7c7e4fdb025bc8ea64f14c4a428c22f94815c9))


### Reverts

* "fix: use non-root user in ansible image ([#83](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/83))" ([af2db44](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/af2db44d566719256c597320c722c2477d238897))


### Tests

* refactor task / ci workflow ([#91](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/91)) ([a928386](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/a92838677c78655c377d04760c784fd6ce51faf7))


### Continuous Integration

* add hadolint stage ([#92](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/92)) ([05822b4](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/05822b41765643abd842d3ad6652c894c7089207))


### Miscellaneous Chores

* **ansible:** add library to python depName renovate string ([94c7900](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/94c7900f1fc6a77f0951944e48856855e366e987))
* **deps:** update alpine/helm docker tag to v3.11.3 (ansible) ([06bb414](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/06bb4141f8b65acf4bd00baa085db6a38326df46))
* **deps:** update bitnami/kubectl docker tag to v1.24.13 (ansible) ([0890be7](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/0890be756eb214e0beb2a961587422d459087ef5))
* **deps:** update dependency ansible to ~=7.4.0 (ansible) ([5c7cca9](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/5c7cca95eefb1b98156d848cf431e6d22bfba616))
* **deps:** update dependency ansible-lint to ~=6.15.0 (ansible) ([4e7a6c8](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/4e7a6c8d620b61788c5644d8dd6df0ad17fbb9d3))
* **deps:** update dependency bitnami-labs/sealed-secrets to v0.20.2 (ansible) ([#70](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/70)) ([f495bcc](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/f495bcc4f61153efb68963d64731a6317767cfa9))
* **deps:** update dependency bitnami-labs/sealed-secrets to v0.20.5 (ansible) ([8e09709](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/8e097093fcbbfecf01d26beb7fc5986f5df949f8))
* **deps:** update dependency databus23/helm-diff to v3.7.0 (ansible) ([fe4edad](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/fe4edad262e1086ca26c18391d92073c244e3ad9))
* **deps:** update dependency mikefarah/yq to v4.33.3 (ansible) ([#81](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/issues/81)) ([6d6533e](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/6d6533ec67dbde402f97d1dde27607421b09df00))
* **deps:** update library/python docker tag to v3.11.3 (ansible) ([ffe4214](https://git.dhl.com/DATA-LAKE-10108/rancher-pipeline-image/commit/ffe4214798acf6f2ae4c964474592fd996e77de3))
