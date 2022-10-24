# cert_read

Reads the SSL certificate from a freely selectable URL and cleanly outputs its attributes. It makes use of [OpenSSL](https://www.openssl.org/).

## Usage:

```bash
git clone https://github.com/ignpelloz/cert_read
cd cert_read
bash cert_read.sh --url URL_HERE
```

### Docker

It can also be run using Docker:

```bash
git clone https://github.com/ignpelloz/cert_read
sudo docker build -t cert_read_img cert_read/
sudo docker run cert_read_img --url URL_HERE
```

## Options

| Option        | Required | Explanation                                                                           |
|---------------|----------|---------------------------------------------------------------------------------------|
| `--url <url>` | Yes      | URL from where the certificate should be taken.                                       |
| `--full`      | No       | When used, the tool will show the full list of details obtained by `openssl`.         |
| `--fullWCert` | No       | Like `--full` but shows the certificate too.                                          |
| `--onlyCert`  | No       | Displays only the encoded certificate.                                                |
| `--json`      | No       | Prints the details in JSON (i.e [jq](https://stedolan.github.io/jq/)-ready sintax).   |

**Note:** the certificate chain is not shown by default, only when the options `--full` or `--fullWCert` are used. 
