FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt ./

#RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . /app

EXPOSE 8085

CMD ["python", "app.py"]