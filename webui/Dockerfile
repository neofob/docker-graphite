# NGINX as web interface for browsing graphite metrics
FROM nginx:latest

COPY --from=graphite_web:test /var/lib/graphite/webapp/content /var/lib/graphite/webapp/content
