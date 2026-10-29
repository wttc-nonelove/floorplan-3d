# 纯静态前端：nginx 托管单文件 index.html
#
# 镜像里只有两样东西：站点文件 + server 配置。
# 不使用多阶段构建——没有编译产物需要搬运，多一层只会增加理解成本。
FROM nginx:alpine

LABEL org.opencontainers.image.title="floorplan-3d" \
      org.opencontainers.image.description="Floor plan 2D/3D design tool — single-file static site on nginx" \
      org.opencontainers.image.source="https://github.com/wttc-nonelove/floorplan-3d" \
      org.opencontainers.image.licenses="MIT"

# 官方镜像自带的示例站点配置由我们的 server 块整体替换
COPY nginx-default.conf /etc/nginx/conf.d/default.conf

# 站点文件：整个应用就这一个文件，CSS/JS 全部内联
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80

# 探测 /healthz 而不是 /：首页是 700+ KB 的单文件，
# 健康检查只该验证 nginx 是否在服务，不该反复拉整个页面。
HEALTHCHECK --interval=30s --timeout=3s --start-period=3s --retries=3 \
  CMD wget -qO- http://127.0.0.1/healthz >/dev/null 2>&1 || exit 1

# nginx 官方镜像已设置 STOPSIGNAL SIGQUIT（优雅退出），此处不重复声明
CMD ["nginx", "-g", "daemon off;"]
