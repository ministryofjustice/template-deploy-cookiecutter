# Install prerequisites first (go, cfssl, jq)
brew install go jq
# Set the correct go path
mkdir $HOME/go
export GOPATH=$HOME/go && export PATH=$PATH:$GOPATH/bin
# Install cfssl
go get -u github.com/cloudflare/cfssl/cmd/cfssl
go get -u github.com/cloudflare/cfssl/cmd/cfssljson

# Clone the repository and unlock it
# If you can't unlock the repository ask <platforms@digital.justice.gov.uk> to do it
git clone git@github.com:ministryofjustice/mojdigital-ca.git && cd mojdigital-ca
git-crypt unlock

# Generate and sign the certificate (replace <myservice> with the name of your service like pvb):
profile=client ./gen-key-and-csr.sh "{{ cookiecutter.project_name }}.internal.moj.digital"

jq -n -r -c \
  --arg cert "$(cat test.internal.moj.digital.pem)" \
  --arg key "$(cat test.internal.moj.digital-key.pem)" \
  --arg chain "$(cat intermediate_ca/ca.pem root_ca/ca.pem)" \
  '.cert = $cert | .chain = $chain | .key = $key | @json'