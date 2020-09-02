### 1.0.1 (2020-09-02)

* **dependencies:** Upgraded dependencies ([#23](https://github.com/lob/litmus/pull/31))

### 1.0.0 (2019-06-17)

##### New Features

* **string:**  Adds :replace option ([#26](https://github.com/lob/litmus/pull/26))
* **list:**  Adds :unique option ([#25](https://github.com/lob/litmus/pull/25))
* **datetime:**  Allows DateTime structs as values and default values ([#24](https://github.com/lob/litmus/pull/24))

##### Internal Changes

* **typespecs:** Corrects typespecs ([#29](https://github.com/lob/litmus/pull/29))
* **required:** Exit early for non-required, non-present field ([#28](https://github.com/lob/litmus/pull/28))
* **dependencies:** Support for Elixir 1.8 and upgraded dependencies ([#23](https://github.com/lob/litmus/pull/23))

### 0.6.0 (2019-05-10)

##### New Features

* **default:**  Adds default option to all types ([#22](https://github.com/lob/litmus/pull/22))

### 0.5.0 (2019-01-02)

##### New Features

* **string:**  Allows nil strings when not required ([#21](https://github.com/lob/litmus/pull/21))

### 0.4.0 (2018-08-28)

##### New Features

* **datetime:**  Added DateTime type ([#20](https://github.com/lob/litmus/pull/20))

### 0.3.0 (2018-08-21)

##### New Features

* **plug:**  Added a validation plug for use with Plug's Router ([#17](https://github.com/lob/litmus/pull/17))

### 0.2.0 (2018-08-06)

##### New Features

* **list-validation:**  Added validation functions and test cases for List data type ([#16](https://github.com/lob/litmus/pull/16)) ([d1977270](https://github.com/lob/litmus/commit/d1977270dc746788966543d646b6612b8621bd09))

#### 0.1.1 (2018-08-02)

##### Chores

* **spec:**  changes binary to String.t() ([#14](https://github.com/lob/litmus/pull/14)) ([f4f7eb23](https://github.com/lob/litmus/commit/f4f7eb23cf21c9d09127eb1f653afb0d013a7169))

##### Bug Fixes

* **allow-nil:**  Convert nil value of data to empty string ([#15](https://github.com/lob/litmus/pull/15)) ([81e570c6](https://github.com/lob/litmus/commit/81e570c600492807fef73a2ac9c47d7c24232ef6))

### 0.1.0 (2018-08-01)

##### Chores

* **add-test:**  Added excoveralls, travis, credo and dialyxir ([#3](https://github.com/lob/litmus/pull/3)) ([8d374e3a](https://github.com/lob/litmus/commit/8d374e3ab8d5441cd4ed6da3fc45eaf4718fda43))
* **add-files:**  Added README.md, LICENSE and CHANGELOG.md files ([#1](https://github.com/lob/litmus/pull/1)) ([99628e7b](https://github.com/lob/litmus/commit/99628e7b89062bab1ac58d6a23227fd456bad4b9))
* **ex_doc:**  added ex_doc to the project ([#2](https://github.com/lob/litmus/pull/2)) ([b47ce805](https://github.com/lob/litmus/commit/b47ce8054087785461eeba7863bd68a75f8d1d0a))

##### New Features

* **number-validation:**  Added validation functions and test cases for Number data type ([#10](https://github.com/lob/litmus/pull/10)) ([1088adbb](https://github.com/lob/litmus/commit/1088adbb6b9083d257e3ed0afb904afd0f1e173e))
* **boolean-validation:**  Added validation functions and test cases for Boolean data type ([#11](https://github.com/lob/litmus/pull/11)) ([c68d44cb](https://github.com/lob/litmus/commit/c68d44cb686df93519b6db2a5bf1773609e415b9))
* **string-validation:**
  *  Convert number and boolean field values to string ([#9](https://github.com/lob/litmus/pull/9)) ([9f849144](https://github.com/lob/litmus/commit/9f84914479411b126a9930b31132f67b06bfd87a))
  *  Added trim and regex validation functions for String data type ([#8](https://github.com/lob/litmus/pull/8)) ([45f29c1b](https://github.com/lob/litmus/commit/45f29c1b6eeaffd9fffa0a2019f3741f54893e88))
  *  Added length related validation functions for String data type ([#7](https://github.com/lob/litmus/pull/7)) ([faa1cbc1](https://github.com/lob/litmus/commit/faa1cbc1dbd55b71a2617d855924b00e24238141))
* **any-validation:**  Added validation functions for Any data type ([#6](https://github.com/lob/litmus/pull/6)) ([840ac038](https://github.com/lob/litmus/commit/840ac03837212322d4ead54801448f575b35e62b))
* **main-validation:**  Added the main entry point for validation ([#5](https://github.com/lob/litmus/pull/5)) ([4b0d3ac2](https://github.com/lob/litmus/commit/4b0d3ac25e69dff8c9a1ae277cef9c4fb02f94eb))
* **add-type:**  Add schemas for each data type ([#4](https://github.com/lob/litmus/pull/4)) ([28c6aa33](https://github.com/lob/litmus/commit/28c6aa33daafa5aff3ee4dd190832039a0a26c8c))

##### Bug Fixes

* **package:**  Publish library on Hex ([#13](https://github.com/lob/litmus/pull/13)) ([430d3241](https://github.com/lob/litmus/commit/430d3241e3c971355c0946c815548039e8267d1b))
* **boolean:**  simplifies check_booelan_values return ([#12](https://github.com/lob/litmus/pull/12)) ([1da07f68](https://github.com/lob/litmus/commit/1da07f6878b339a76f5b3a5f83b9c9cfde16735b))
