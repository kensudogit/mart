package main.java.com.intramart.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * ホーム画面用コントローラー
 */
@Controller
public class HomeController {

    /**
     * ホーム画面を表示
     */
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home(Model model) {
        model.addAttribute("message", "intra-mart環境へようこそ！");
        model.addAttribute("version", "1.0.0");
        return "home";
    }

    /**
     * ログイン画面を表示
     */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String login(Model model) {
        return "login";
    }

    /**
     * ダッシュボード画面を表示
     */
    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public String dashboard(Model model) {
        model.addAttribute("title", "ダッシュボード");
        return "dashboard";
    }
}
