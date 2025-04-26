package DAO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import DTO.VoucherInfoDTO;
import Models.Accounts.BankType;
import Models.Accounts.PaymentCard;
import Models.Accounts.ShippingInformation;
import Models.Accounts.Voucher;
import Models.Users.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.Cache.Redis;
import mvc.Cache.Redis.CacheLevel;
import mvc.DataAccess;
import mvc.Helpers.Helpers;
import mvc.Helpers.JsonConverter;
import mvc.Helpers.Notify.Notification;

public class AccountDA {
    private EntityManager db = DataAccess.getEntityManager();
    private UserDA userDA = new UserDA();
    private Redis cache = new Redis();

    public List<ShippingInformation> getShippingInformation(int userId) {
        List<ShippingInformation> shippingAddresses = null;
        User user = null;

        TypedQuery<User> typedQuery = this.db.createQuery("SELECT u FROM User u WHERE id =:id", User.class)
                .setParameter("id", userId);
        try {
            user = cache.getOrCreate("user-" + userId, User.class, typedQuery);
        } catch (Exception e) {
            user = typedQuery.getSingleResult(); // run without cache if cache fails
        }
        try {
            shippingAddresses = JsonConverter.deserialize(user.getShippingInformation(), ShippingInformation.class);
        } catch (Exception e) {
            return null;
        }
        return shippingAddresses;
    }

    public boolean addShippingInformation(int userId, ShippingInformation ShippingAddress) {
        List<ShippingInformation> shippingInformations = getShippingInformation(userId);
        User user = userDA.getUserById(userId);
        String json = "";

        if (user == null) {
            return false;
        }

        if (shippingInformations == null) {
            shippingInformations = new ArrayList<>();
        }
        ShippingAddress.setId(shippingInformations.size() + 1);
        shippingInformations.add(ShippingAddress);

        try {
            json = JsonConverter.serialize(shippingInformations);
        } catch (Exception e) {
            return false;
        }

        if ("".equals(json)) {
            return false;
        }

        user.setShippingInformation(json);

        boolean result = userDA.updateUser(user);

        return result;
    }

    public boolean updateShippingInformation(int userId, ShippingInformation shippingInformation) {
        List<ShippingInformation> shippingInformations = getShippingInformation(userId);
        User user = userDA.getUserById(userId);
        String json = "";

        if (user == null) {
            return false;
        }

        if (shippingInformations == null) {
            return false;
        }

        for (int i = 0; i < shippingInformations.size(); i++) {
            if (shippingInformations.get(i).getId() != shippingInformation.getId()) {
                continue;
            }
            // set based on property one by one to avoid null values overwriting to existing
            // values
            ShippingInformation shippingInfo = shippingInformations.get(i);
            shippingInfo.setLabel(shippingInformation.getLabel());
            shippingInfo.setReceiverName(shippingInformation.getReceiverName());
            shippingInfo.setPhoneNumber(shippingInformation.getPhoneNumber());
            shippingInfo.setState(shippingInformation.getState());
            shippingInfo.setPostCode(shippingInformation.getPostCode());
            shippingInfo.setAddressLine1(shippingInformation.getAddressLine1());
            shippingInfo.setAddressLine2(shippingInformation.getAddressLine2());
            break;
        }

        try {
            json = JsonConverter.serialize(shippingInformations);
        } catch (Exception e) {
            return false;
        }

        if ("".equals(json)) {
            return false;
        }

        user.setShippingInformation(json);

        boolean result = userDA.updateUser(user);
        return result;
    }

    public boolean deleteShippingInformation(int userId, int shippingInformationId) {
        List<ShippingInformation> shippingInformations = getShippingInformation(userId);
        User user = userDA.getUserById(userId);
        if (user == null) {
            return false;
        }

        if (shippingInformations == null) {
            return false;
        }
        String json = "";
        int toRemoveId = -1;
        for (int i = 0; i < shippingInformations.size(); i++) {
            if (shippingInformations.get(i).getId() != shippingInformationId) {
                continue;
            }
            toRemoveId = i;
            break;
        }
        shippingInformations.remove(toRemoveId);

        try {
            json = JsonConverter.serialize(shippingInformations);
        } catch (Exception e) {
            return false;
        }

        if ("".equals(json)) {
            return false;
        }

        user.setShippingInformation(json);

        boolean result = userDA.updateUser(user);
        return result;
    }

    public boolean setDefaultShippingInformation(int userId, int shippingInformationId) {

        List<ShippingInformation> shippingInformations = getShippingInformation(userId);
        User user = userDA.getUserById(userId);
        String json = "";

        if (user == null) {
            return false;
        }

        if (shippingInformations == null) {
            return false;
        }
        for (int i = 0; i < shippingInformations.size(); i++) {
            if (shippingInformations.get(i).getId() != shippingInformationId) {
                shippingInformations.get(i).setDefault(false);
                continue;
            }
            shippingInformations.get(i).setDefault(true);
        }

        try {
            json = JsonConverter.serialize(shippingInformations);
        } catch (Exception e) {
            return false;
        }

        if ("".equals(json)) {
            return false;
        }

        user.setShippingInformation(json);
        boolean result = userDA.updateUser(user);
        return result;
    }

    public List<BankType> getBankTypes() {
        List<BankType> bankTypes = null;

        TypedQuery<BankType> typedQuery = this.db.createQuery("SELECT bank FROM BankType bank", BankType.class);
        try {
            bankTypes = cache.getOrCreateList("banktypes", BankType.class, typedQuery);
        } catch (Exception e) {
            bankTypes = typedQuery.getResultList(); // run without cache if cache fails
        }
        return bankTypes;
    }

    public BankType getBankType(int id) {
        BankType bankType = null;
        TypedQuery<BankType> typedQuery = this.db
                .createQuery("SELECT bank FROM BankType bank WHERE id = :id", BankType.class)
                .setParameter("id", id);
        try {
            bankType = cache.getOrCreate("banktype", BankType.class, typedQuery);
        } catch (Exception e) {
            bankType = typedQuery.getSingleResult(); // run without cache if cache fails
        }
        return bankType;
    }

    public boolean addPaymentCard(PaymentCard paymentCard, int userId) {
        User user = userDA.getUserById(userId);
        BankType bank = getBankType(paymentCard.getBankTypeId()); // default to first bank type
        if (user == null) {
            return false;
        }

        if (bank == null) {
            return false;
        }
        db.getTransaction().begin();
        paymentCard.setUser(user);
        paymentCard.setBankType(bank);
        db.persist(paymentCard);
        db.getTransaction().commit();

        return !db.getTransaction().getRollbackOnly();
    }

    public List<PaymentCard> getPaymentCards(int userId) {
        List<PaymentCard> paymentCards = null;
        TypedQuery<PaymentCard> typedQuery = this.db
                .createQuery(
                        "SELECT info FROM PaymentCard info LEFT JOIN FETCH info.bankType LEFT JOIN FETCH info.user WHERE info.user.id = :id",
                        PaymentCard.class)
                .setParameter("id", userId);
        try {
            paymentCards = cache.getOrCreateList("user-payment-info-by-userId-" + userId, PaymentCard.class,
                    typedQuery, CacheLevel.LOW);
        } catch (Exception e) {
            paymentCards = typedQuery.getResultList(); // run without cache if cache fails
        }
        return paymentCards;
    }

    public PaymentCard getPaymentCard(int cardId) {
        PaymentCard paymentCard = null;
        TypedQuery<PaymentCard> typedQuery = this.db
                .createQuery(
                        "SELECT info FROM PaymentCard info LEFT JOIN FETCH info.bankType LEFT JOIN FETCH info.user WHERE info.id = :id",
                        PaymentCard.class)
                .setParameter("id", cardId);
        try {
            paymentCard = cache.getOrCreate("user-payment-info-by-id-" + cardId, PaymentCard.class, typedQuery,
                    CacheLevel.LOW);
        } catch (Exception e) {
            System.out.println("Cache failed, running without cache.");
            System.out.println("Error at getPaymentCard: " + e.getMessage());
            paymentCard = typedQuery.getSingleResult(); // run without cache if cache fails
        }

        return paymentCard;
    }

    public boolean setDefaultPaymentCard(int userId, int cardId) {
        List<PaymentCard> paymentCards = getPaymentCards(userId);
        System.out.println("PaymentCard ID: " + cardId);
        System.out.println("PaymentCards: " + paymentCards);
        if (paymentCards == null) {
            return false;
        }
        db.getTransaction().begin();
        // set others to false
        for (int i = 0; i < paymentCards.size(); i++) {
            System.out.println("PaymentCard ID: " + paymentCards.get(i).getId() + " Card ID: " + cardId);
            if (paymentCards.get(i).getId() != cardId) {
                paymentCards.get(i).setDefault(false);
                db.merge(paymentCards.get(i));
                continue;
            }
            paymentCards.get(i).setDefault(true);
            db.merge(paymentCards.get(i));
        }
        db.getTransaction().commit();

        return !db.getTransaction().getRollbackOnly();
    }

    public boolean updatePaymentCard(PaymentCard paymentCard) {
        System.out.println("Updating payment card with ID: " + paymentCard.getId());
        PaymentCard existingPaymentCard = getPaymentCard(paymentCard.getId());
        System.out.println("Updating payment card: " + existingPaymentCard);
        System.out.println("New payment card: " + paymentCard);
        if (existingPaymentCard == null) {
            return false;
        }

        db.getTransaction().begin();
        // Update the existing payment card with new values
        existingPaymentCard.setName(paymentCard.getName());
        existingPaymentCard.setCardNumber(paymentCard.getCardNumber());
        existingPaymentCard.setExpiryDate(paymentCard.getExpiryDate());
        existingPaymentCard.setBankTypeId(paymentCard.getBankTypeId());
        db.merge(existingPaymentCard);
        db.getTransaction().commit();

        return !db.getTransaction().getRollbackOnly();
    }

    public boolean deletePaymentCard(int cardId) {
        System.out.println("Deleting payment card with ID: " + cardId);
        PaymentCard paymentCard = getPaymentCard(cardId);
        System.out.println("Payment card found: " + paymentCard);
        if (paymentCard == null) {
            return false;
        }
        db.getTransaction().begin();
        db.remove(paymentCard);
        db.getTransaction().commit();
        System.out.println("Payment card deleted successfully.");

        return !db.getTransaction().getRollbackOnly();
    }

    public boolean verifyPassword(int userId, String entryPassword) {
        String password = userDA.getUserPasswordById(userId);
        if (null == password || "".equals(password)) {
            return false;
        }
        if (Helpers.verifyPassword(entryPassword, password)) {
            return true;
        }
        return false;
    }

    public boolean changePassword(int userId, String password) {
        User user = userDA.getUserById(userId);
        if (user == null) {
            return false;
        }
        password = Helpers.hashPassword(password);
        user.setPassword(password);

        db.getTransaction().begin();
        db.merge(user);
        db.getTransaction().commit();

        return !db.getTransaction().getRollbackOnly();
    }

    public boolean changePassword(String email, String password) {
        User user = userDA.getUserByEmail(email);
        if (user == null) {
            return false;
        }
        password = Helpers.hashPassword(password);
        user.setPassword(password);

        db.getTransaction().begin();
        db.merge(user);
        db.getTransaction().commit();

        return !db.getTransaction().getRollbackOnly();
    }

    public List<Voucher> getVouchers() {
        List<Voucher> vouchers = null;
        TypedQuery<Voucher> typedQuery = this.db.createQuery("SELECT v FROM Voucher v", Voucher.class);

        try {
            vouchers = cache.getOrCreateList("vouchers", Voucher.class, typedQuery, CacheLevel.CRITICAL);
        } catch (Exception e) {
            vouchers = typedQuery.getResultList();
        }
        return vouchers;
    }

    public Voucher getVoucher(int voucherId) {
        Voucher voucher = null;
        TypedQuery<Voucher> typedQuery = this.db.createQuery("SELECT v FROM Voucher v WHERE id = :id",
                Voucher.class)
                .setParameter("id", voucherId);

        try {
            voucher = cache.getOrCreate("voucher-" + voucherId, Voucher.class,
                    typedQuery, CacheLevel.CRITICAL);
        } catch (Exception e) {
            System.out.println(e.getMessage());
            // voucher = typedQuery.getSingleResult();
        }
        return voucher;
    }

    public boolean addVoucher(Voucher voucher) {
        db.getTransaction().begin();
        db.persist(voucher);
        db.getTransaction().commit();
        return !db.getTransaction().getRollbackOnly();
    }

    public boolean updateVoucherStatus(int voucherId, boolean status) {
        Voucher voucher = getVoucher(voucherId);
        voucher.setStatus(status ? 1 : 0); // 1 = active, 0 = inactive

        db.getTransaction().begin();
        db.merge(voucher);
        db.getTransaction().commit();
        return !db.getTransaction().getRollbackOnly();
    }

    public List<Voucher> getAvailableVouchers(User user, double cartTotal) {
        List<Voucher> eligibleVouchers = null;

        String queryStr = """
                    SELECT v FROM Voucher v
                    WHERE v.status = 1
                    AND :cartTotal >= v.minSpent
                    AND (
                        SELECT COUNT(o) FROM Order o
                        WHERE o.user.id = :userId
                        AND o.payment.voucher.id = v.id
                        AND o.orderDate >= :thirtyDaysAgo
                    ) < v.usagePerMonth
                """;

        // Format 30 days ago as string: "yyyy-MM-dd HH:mm:ss"
        LocalDateTime nowMinus30 = LocalDateTime.now().minusDays(30);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String thirtyDaysAgo = nowMinus30.format(formatter);

        TypedQuery<Voucher> query = db.createQuery(queryStr, Voucher.class)
                .setParameter("userId", user.getId())
                .setParameter("cartTotal", cartTotal)
                .setParameter("thirtyDaysAgo", thirtyDaysAgo);

        try {
            eligibleVouchers = cache.getOrCreateList(
                    "eligible-vouchers-user-" + user.getId() + "-cart-" + cartTotal,
                    Voucher.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            eligibleVouchers = query.getResultList(); // fallback
        }

        return eligibleVouchers;
    }

    public VoucherInfoDTO getVoucherInfo(int voucherId, User user) {
        Voucher voucher = getVoucher(voucherId);
        if (voucher == null || user == null) {
            return null;
        }

        try {
            String queryStr = """
                        SELECT COUNT(o) FROM Order o
                        WHERE o.user.id = :userId
                        AND o.payment.voucher.id = :voucherId
                        AND o.orderDate >= :thirtyDaysAgo
                    """;

            String thirtyDaysAgo = LocalDateTime.now()
                    .minusDays(30)
                    .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

            TypedQuery<Long> query = db.createQuery(queryStr, Long.class)
                    .setParameter("userId", user.getId())
                    .setParameter("voucherId", voucherId)
                    .setParameter("thirtyDaysAgo", thirtyDaysAgo);

            Long usedThisMonth = query.getSingleResult();

            VoucherInfoDTO voucherInfo = new VoucherInfoDTO(voucher, usedThisMonth.intValue());
            voucherInfo.setDeduction(0);
            voucherInfo.setTotalAfterDeduction(0);

            return voucherInfo;

        } catch (Exception e) {
            e.printStackTrace(); // or use a proper logger if available
            return null;
        }
    }

    public List<VoucherInfoDTO> getAllVoucherInfo(int userId) {
        User user = userDA.getUserById(userId);
        List<Voucher> vouchers = getVouchers();
        List<VoucherInfoDTO> voucherInfoList = null;
        if (vouchers == null || user == null) {
            return null;
        }
        for(Voucher voucher : vouchers) {
            VoucherInfoDTO voucherInfo = getVoucherInfo(voucher.getId(), user);
            if (voucherInfo == null) {
                continue;
            }
            if (voucherInfoList == null) {
                voucherInfoList = new ArrayList<>();
            }
            voucherInfoList.add(voucherInfo);
        }

        if (voucherInfoList == null) {
            return null;
        }else {
            return voucherInfoList;
        }
    }

    public List<Notification> getNotifications(int id) {
        List<Notification> notifications = null;
        TypedQuery<Notification> typedQuery = this.db.createQuery("SELECT n FROM Notification n WHERE n.user.id = :id",
                Notification.class)
                .setParameter("id", id);
        try {
            notifications = cache.getOrCreateList("user-notifications-" + id, Notification.class, typedQuery,
                    CacheLevel.CRITICAL);
        } catch (Exception e) {
            notifications = typedQuery.getResultList(); // run without cache if cache fails
        }
        return notifications;
    }

    public Notification getNotificationById(int id) {
        Notification notification = null;
        TypedQuery<Notification> typedQuery = this.db.createQuery("SELECT n FROM Notification n WHERE id = :id",
                Notification.class)
                .setParameter("id", id);
        try {
            notification = cache.getOrCreate("notification-" + id, Notification.class, typedQuery, CacheLevel.CRITICAL);
        } catch (Exception e) {
            notification = typedQuery.getSingleResult(); // run without cache if cache fails
        }
        return notification;
    }

    public String triggerReadNotification(int id) {
        Notification notification = getNotificationById(id);
        if (notification == null) {
            return null;
        }
        notification.setRead(true);
        notification.setReadAt(Helpers.getCurrentDateTime());
        db.getTransaction().begin();
        db.merge(notification);
        db.getTransaction().commit();
        return notification.getUrl();
    }
}
