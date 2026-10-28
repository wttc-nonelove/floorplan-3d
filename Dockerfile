# 纯静态前端：用 nginx 托管单文件 index.html
FROM nginx:alpine

LABEL maintainer="floorplan-3d" \
      description="Floor plan 2D/3D design tool (static site)"

# 自定义 server 配置（开启 gzip、SPA 回退）
COPY nginx-default.conf /etc/nginx/conf.d/default.conf

# 站点文件
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://127.0.0.1/ >/dev/null 2>&1 || exit 1

CMD ["nginx", "-g", "daemon off;"]
