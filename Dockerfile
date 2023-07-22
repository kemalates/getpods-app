FROM debian:buster

RUN apt update && \
      apt install -y curl unzip groff && \
      curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
      chmod +x ./kubectl && \
      mv ./kubectl /usr/local/bin/kubectl

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
	./aws/install

COPY scripts/getpods.sh /
RUN chmod +x /getpods.sh

CMD /getpods.sh



#CMD kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}" |\
#tr -s '[[:space:]]' '\n' |\
#sort |\
#uniq -c
# CMD echo hello world