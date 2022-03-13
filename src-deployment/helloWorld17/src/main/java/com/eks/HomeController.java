package com.eks;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {
	
	@RequestMapping("/home")
	public String showHomePage(){
		System.out.println("Controller invoked");
		return "home";
	}

}
