FROM python:3.8-slim

# Make a user
ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
  && chown -R user:user $HOME \
  && usermod -a -G audio,video user

WORKDIR /app
USER user
ADD --chown=user:user . /app/
RUN pip install -r requirements.txt
ENV PATH=/app/bin:$PATH
WORKDIR $HOME/repo
#CMD ["/home/user/Telegram"]
