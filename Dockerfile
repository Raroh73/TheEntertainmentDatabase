FROM swift:6.0 AS builder
WORKDIR /build
COPY ./Package.* .
RUN swift package resolve
COPY . .
RUN swift build --configuration release --static-swift-stdlib
WORKDIR /staging
RUN cp "$(swift build --configuration release --package-path /build --show-bin-path)/TheEntertainmentDatabase" .
RUN cp --recursive /build/Public .
RUN cp --recursive /build/Resources .

FROM ubuntu:24.04 AS runner
RUN useradd --create-home --home-dir /app --user-group --system theentertainmentdatabase
USER theentertainmentdatabase
WORKDIR /app
COPY --chown=theentertainmentdatabase:theentertainmentdatabase --from=builder /staging .
EXPOSE 8080
ENTRYPOINT ["./TheEntertainmentDatabase"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
