package main

import (
        "log"
        "net/http"
)

func main() {
        _, err := http.Get("https://go.dev/")
        if err != nil {
                log.Fatal(err) 
        } else {
                log.Println("ok")
	}
}
