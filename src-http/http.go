package main

import (
        "log"
        "net/http"
)

func main() {
        _, err := http.Get("http://example.com/")
        if err != nil {
			log.Fatal(err) 
        } else {
			log.Println("ok")
		}
}
