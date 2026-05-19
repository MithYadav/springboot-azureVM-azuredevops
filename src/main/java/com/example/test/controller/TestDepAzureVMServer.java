package com.example.test.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/testazurevm")
public class TestDepAzureVMServer {

	@GetMapping
	public ResponseEntity<String> checkDepStatus() {

		return ResponseEntity.ok("Spring app deployed on azureVM using azuredevops successfully");
	}

}
