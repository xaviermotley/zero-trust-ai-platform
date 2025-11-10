package main

import (
    "io"
    "log"
    "net/http"
    "net/url"
    "os"
)

func main() {
    target := os.Getenv("INFERENCE_URL")
    if target == "" {
        log.Fatal("INFERENCE_URL not set")
    }
    targetURL, err := url.Parse(target)
    if err != nil {
        log.Fatalf("invalid INFERENCE_URL: %v", err)
    }

    handler := func(w http.ResponseWriter, r *http.Request) {
        proxyURL := targetURL.ResolveReference(r.URL)
        req, err := http.NewRequestWithContext(r.Context(), r.Method, proxyURL.String(), r.Body)
        if err != nil {
            http.Error(w, err.Error(), http.StatusBadRequest)
            return
        }
        req.Header = r.Header.Clone()
        resp, err := http.DefaultClient.Do(req)
        if err != nil {
            http.Error(w, err.Error(), http.StatusBadGateway)
            return
        }
        defer resp.Body.Close()
        for k, vals := range resp.Header {
            for _, v := range vals {
                w.Header().Add(k, v)
            }
        }
        w.WriteHeader(resp.StatusCode)
        io.Copy(w, resp.Body)
    }

    http.HandleFunc("/", handler)
    log.Fatal(http.ListenAndServe(":8080", nil))
}
