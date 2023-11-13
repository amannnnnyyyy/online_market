#FROM python:3.8-alpine
#ENV PYTHONBUFFERED=1
#WORKDIR /django_docker
#COPY requirements.txt requirements.txt
#RUN pip3 install -r requirements.txt
#COPY . .
#EXPOSE 8000
#CMD python3 manage.py runserver 0.0.0.0:8000


FROM python:3.8-alpine AS builder
WORKDIR /app
RUN python -m venv .venv && .venv/bin/pip install --no-cache-dir -U pip setuptools
COPY requirements.txt .
RUN .venv/bin/pip install --no-cache-dir -r requirements.txt \
    && find /app/.venv \( -type d -a \( -name test -o -name tests \) \) -o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) -exec rm -rf '{}' \+

FROM python:3.8-alpine
WORKDIR /app
COPY --from=builder /app /app
COPY . .
ENV PATH="/app/.venv/bin:$PATH"
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]