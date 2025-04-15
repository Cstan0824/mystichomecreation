package DAO;

import java.util.List;

import Models.Accounts.BankType;
import Models.Accounts.PaymentCard;
import Models.Accounts.ShippingInformation;
import Models.Accounts.Voucher;
import Models.Users.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.DataAccess;
import mvc.Cache.Redis;
import mvc.Cache.Redis.CacheLevel;
import mvc.Helpers.JsonConverter;

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
            return false;
        }
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

    public boolean addPaymentCard(PaymentCard paymentCard) {
        db.getTransaction().begin();
        db.persist(paymentCard);
        db.getTransaction().commit();

        return db.getTransaction().getRollbackOnly();
    }

    public List<PaymentCard> getPaymentCards(int userId) {
        List<PaymentCard> paymentCards = null;
        TypedQuery<PaymentCard> typedQuery = this.db
                .createQuery("SELECT info FROM PaymentCard info LEFT JOIN FETCH info.bankType WHERE info.user.id = :id",
                        PaymentCard.class)
                .setParameter("id", userId);
        try {
            paymentCards = cache.getOrCreateList("users-payment-info-by-userId-" + userId, PaymentCard.class,
                    typedQuery, CacheLevel.LOW);
        } catch (Exception e) {
            paymentCards = typedQuery.getResultList(); // run without cache if cache fails
        }
        return paymentCards;
    }

    public PaymentCard getPaymentCard(int cardId) {
        PaymentCard paymentCard = null;
        TypedQuery<PaymentCard> typedQuery = this.db
                .createQuery("SELECT info FROM PaymentCard info WHERE id = :id",
                        PaymentCard.class)
                .setParameter("id", cardId);
        try {
            paymentCard = cache.getOrCreate("users-payment-info-by-id-" + cardId, PaymentCard.class, typedQuery,
                    CacheLevel.LOW);
        } catch (Exception e) {
            paymentCard = typedQuery.getSingleResult(); // run without cache if cache fails
        }

        return paymentCard;
    }

    public boolean setDefaultPaymentCard(int userId, int cardId) {
        List<PaymentCard> paymentCards = getPaymentCards(userId);
        if (paymentCards == null) {
            return false;
        }
        db.getTransaction().begin();
        // set others to false
        for (int i = 0; i < paymentCards.size(); i++) {
            if (paymentCards.get(i).getId() != cardId) {
                paymentCards.get(i).setDefault(false);
                db.merge(paymentCards.get(i));
                continue;
            }
            paymentCards.get(i).setDefault(true);
            db.merge(paymentCards.get(i));
        }
        db.getTransaction().commit();

        return db.getTransaction().getRollbackOnly();
    }

    public boolean updatePaymentCard(PaymentCard paymentCard) {
        db.getTransaction().begin();
        db.merge(paymentCard);
        db.getTransaction().commit();

        return db.getTransaction().getRollbackOnly();
    }

    public boolean deletePaymentCard(int cardId) {
        PaymentCard paymentCard = getPaymentCard(cardId);
        if (paymentCard == null) {
            return false;
        }
        db.getTransaction().begin();
        db.remove(paymentCard);
        db.getTransaction().commit();

        return db.getTransaction().getRollbackOnly();
    }

    public boolean verifyPassword(int userId, String password) {
        User user = userDA.getUserById(userId);
        if (user == null) {
            return false;
        }
        if (user.getPassword().equals(password)) { // Need to hash the password before compare
            return true;
        }
        return false;
    }

    public boolean changePassword(int userId, String password) {
        User user = userDA.getUserById(userId);
        if (user == null) {
            return false;
        }

        user.setPassword(password); // TODO: Hash Function

        db.getTransaction().begin();
        db.merge(user);
        db.getTransaction().commit();

        return db.getTransaction().getRollbackOnly();
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
            voucher = cache.getOrCreate("voucher-" + voucherId, Voucher.class, typedQuery, CacheLevel.CRITICAL);
        } catch (Exception e) {
            voucher = typedQuery.getSingleResult();
        }
        return voucher;
    }

    public boolean addVoucher(Voucher voucher) {
        db.getTransaction().begin();
        db.persist(voucher);
        db.getTransaction().commit();
        return db.getTransaction().getRollbackOnly();
    }

    public boolean updateVoucherStatus(int voucherId, boolean status) {
        Voucher voucher = getVoucher(voucherId);
        voucher.setStatus(status);

        db.getTransaction().begin();
        db.merge(voucher);
        db.getTransaction().commit();
        return db.getTransaction().getRollbackOnly();
    }
}
