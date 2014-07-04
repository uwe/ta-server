package main

import (
    "io"
    "log"
    "net/http"
)

func RootHandler(w http.ResponseWriter, r *http.Request) {
    io.WriteString(w, "Hallo Uwe")
}

func main() {
    http.HandleFunc("/", RootHandler)
    log.Fatal(http.ListenAndServe(":3000", nil))
}

