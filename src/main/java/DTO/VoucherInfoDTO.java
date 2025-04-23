package DTO;

import Models.Accounts.Voucher;

public class VoucherInfoDTO {
    private Voucher voucher;
    private int usedThisMonth;
    private int usageLeft;
    private double deduction;
    private double totalAfterDeduction;

    public VoucherInfoDTO(Voucher voucher, int usedThisMonth){
        this.voucher = voucher;
        this.usedThisMonth = usedThisMonth;
        this.usageLeft = voucher.getUsagePerMonth() - usedThisMonth;
    }

    public Voucher getVoucher() {
        return voucher;
    }

    public void setVoucher(Voucher voucher){
        this.voucher = voucher;
    }

    public int getUsedThisMonth() {
        return usedThisMonth;
    }

    public void setUsedThisMonth(int usedThisMonth){
        this.usedThisMonth = usedThisMonth;
    }

    public int getUsageLeft() {
        return usageLeft;
    }

    public void setUsageLeft(int usageLeft){
        this.usageLeft = usageLeft;
    }

    public double getDeduction(){
        return deduction;
    }

    public void setDeduction(double deduction){
        this.deduction = deduction;
    }

    public double getTotalAfterDeduction(){
        return totalAfterDeduction;
    }

    public void setTotalAfterDeduction(double totalAfterDeduction){
        this.totalAfterDeduction = totalAfterDeduction;
    }
}