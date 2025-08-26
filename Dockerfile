FROM python:3.12-alpine

WORKDIR /app
EXPOSE 9000
COPY app/src/app.py app/requirements.txt ./
RUN pip install -r requirements.txt
ENTRYPOINT [ "python" ]
CMD ["app.py" ]
