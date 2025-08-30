package com.intramart.warehouse.controller;

import com.intramart.warehouse.model.Product;
import com.intramart.warehouse.model.Inventory;
import com.intramart.warehouse.model.Transaction;
import com.intramart.warehouse.service.WarehouseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

/**
 * 倉庫管理システムのメインコントローラー
 */
@Controller
@RequestMapping("/warehouse")
public class WarehouseController {

    @Autowired
    private WarehouseService warehouseService;

    /**
     * ダッシュボード表示
     */
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        try {
            // 在庫サマリー情報を取得
            Map<String, Object> summary = warehouseService.getInventorySummary();
            model.addAttribute("summary", summary);

            // 低在庫商品リスト
            List<Map<String, Object>> lowStockProducts = warehouseService.getLowStockProducts();
            model.addAttribute("lowStockProducts", lowStockProducts);

            // 最近の入出庫履歴
            List<Transaction> recentTransactions = warehouseService.getRecentTransactions(10);
            model.addAttribute("recentTransactions", recentTransactions);

            // 在庫価値の統計
            Map<String, Object> valueStats = warehouseService.getInventoryValueStats();
            model.addAttribute("valueStats", valueStats);

            return "warehouse/dashboard";
        } catch (Exception e) {
            model.addAttribute("error", "ダッシュボードの読み込みに失敗しました: " + e.getMessage());
            return "warehouse/dashboard";
        }
    }

    /**
     * 在庫一覧表示
     */
    @GetMapping("/inventory")
    public String inventoryList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String category,
            Model model) {
        try {
            Map<String, Object> result = warehouseService.getInventoryList(page, size, search, category);
            model.addAttribute("inventoryList", result.get("inventoryList"));
            model.addAttribute("pagination", result.get("pagination"));
            model.addAttribute("search", search);
            model.addAttribute("category", category);
            model.addAttribute("categories", warehouseService.getAllCategories());
            return "warehouse/inventory/list";
        } catch (Exception e) {
            model.addAttribute("error", "在庫一覧の読み込みに失敗しました: " + e.getMessage());
            return "warehouse/inventory/list";
        }
    }

    /**
     * 商品詳細表示
     */
    @GetMapping("/product/{productId}")
    public String productDetail(@PathVariable Long productId, Model model) {
        try {
            Product product = warehouseService.getProductById(productId);
            if (product == null) {
                model.addAttribute("error", "商品が見つかりません");
                return "warehouse/product/detail";
            }

            List<Inventory> inventoryList = warehouseService.getInventoryByProduct(productId);
            List<Transaction> transactionHistory = warehouseService.getTransactionHistory(productId);

            model.addAttribute("product", product);
            model.addAttribute("inventoryList", inventoryList);
            model.addAttribute("transactionHistory", transactionHistory);
            return "warehouse/product/detail";
        } catch (Exception e) {
            model.addAttribute("error", "商品詳細の読み込みに失敗しました: " + e.getMessage());
            return "warehouse/product/detail";
        }
    }

    /**
     * 入庫処理画面表示
     */
    @GetMapping("/inbound")
    public String inboundForm(Model model) {
        model.addAttribute("warehouses", warehouseService.getAllWarehouses());
        model.addAttribute("products", warehouseService.getAllActiveProducts());
        return "warehouse/transaction/inbound";
    }

    /**
     * 入庫処理実行
     */
    @PostMapping("/inbound")
    public String processInbound(
            @RequestParam Long productId,
            @RequestParam Long warehouseId,
            @RequestParam String locationCode,
            @RequestParam Integer quantity,
            @RequestParam(required = false) String lotNumber,
            @RequestParam(required = false) String notes,
            RedirectAttributes redirectAttributes) {
        try {
            Transaction transaction = warehouseService.processInbound(
                productId, warehouseId, locationCode, quantity, lotNumber, notes);
            
            redirectAttributes.addFlashAttribute("success", 
                "入庫処理が完了しました。取引番号: " + transaction.getTransactionId());
            return "redirect:/warehouse/dashboard";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "入庫処理に失敗しました: " + e.getMessage());
            return "redirect:/warehouse/inbound";
        }
    }

    /**
     * 出庫処理画面表示
     */
    @GetMapping("/outbound")
    public String outboundForm(Model model) {
        model.addAttribute("warehouses", warehouseService.getAllWarehouses());
        model.addAttribute("products", warehouseService.getAllActiveProducts());
        return "warehouse/transaction/outbound";
    }

    /**
     * 出庫処理実行
     */
    @PostMapping("/outbound")
    public String processOutbound(
            @RequestParam Long productId,
            @RequestParam Long warehouseId,
            @RequestParam String locationCode,
            @RequestParam Integer quantity,
            @RequestParam(required = false) String notes,
            RedirectAttributes redirectAttributes) {
        try {
            Transaction transaction = warehouseService.processOutbound(
                productId, warehouseId, locationCode, quantity, notes);
            
            redirectAttributes.addFlashAttribute("success", 
                "出庫処理が完了しました。取引番号: " + transaction.getTransactionId());
            return "redirect:/warehouse/dashboard";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "出庫処理に失敗しました: " + e.getMessage());
            return "redirect:/warehouse/outbound";
        }
    }

    /**
     * 棚卸し画面表示
     */
    @GetMapping("/cycle-count")
    public String cycleCountForm(Model model) {
        model.addAttribute("warehouses", warehouseService.getAllWarehouses());
        return "warehouse/cycle-count/form";
    }

    /**
     * 棚卸し実行
     */
    @PostMapping("/cycle-count")
    public String processCycleCount(
            @RequestParam Long warehouseId,
            @RequestParam String locationCode,
            @RequestParam Long productId,
            @RequestParam Integer actualQuantity,
            @RequestParam(required = false) String notes,
            RedirectAttributes redirectAttributes) {
        try {
            Transaction transaction = warehouseService.processCycleCount(
                warehouseId, locationCode, productId, actualQuantity, notes);
            
            redirectAttributes.addFlashAttribute("success", 
                "棚卸しが完了しました。取引番号: " + transaction.getTransactionId());
            return "redirect:/warehouse/cycle-count";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "棚卸しに失敗しました: " + e.getMessage());
            return "redirect:/warehouse/cycle-count";
        }
    }

    /**
     * レポート画面表示
     */
    @GetMapping("/reports")
    public String reports(Model model) {
        try {
            // 在庫レポート
            Map<String, Object> inventoryReport = warehouseService.getInventoryReport();
            model.addAttribute("inventoryReport", inventoryReport);

            // 入出庫レポート
            Map<String, Object> transactionReport = warehouseService.getTransactionReport();
            model.addAttribute("transactionReport", transactionReport);

            return "warehouse/reports/index";
        } catch (Exception e) {
            model.addAttribute("error", "レポートの読み込みに失敗しました: " + e.getMessage());
            return "warehouse/reports/index";
        }
    }

    /**
     * 設定画面表示
     */
    @GetMapping("/settings")
    public String settings(Model model) {
        try {
            model.addAttribute("warehouses", warehouseService.getAllWarehouses());
            model.addAttribute("categories", warehouseService.getAllCategories());
            return "warehouse/settings/index";
        } catch (Exception e) {
            model.addAttribute("error", "設定の読み込みに失敗しました: " + e.getMessage());
            return "warehouse/settings/index";
        }
    }
}
