FROM python:3.12-slim
RUN pip install uv
RUN --mount=source=dist,target=/dist uv pip install --system --no-cache /dist/*.whl

COPY .env* .

EXPOSE 7860
CMD sodeda-era5 dashboard --host 0.0.0.0 --port 7860
