package net.kadirderer.btc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import net.kadirderer.btc.db.criteria.UserOrderCriteria;
import net.kadirderer.btc.db.dao.UserOrderDao;
import net.kadirderer.btc.db.model.UserOrder;
import net.kadirderer.btc.web.dto.DatatableAjaxResponse;

@Service
public class UserOrderServiceImpl implements UserOrderService {

	@Autowired
	private UserOrderDao userOrderDao;
	
	@Override
	public List<UserOrder> findAllByUsername(String username) {
		return userOrderDao.findByUsername(username);
	}

	@Override
	public List<UserOrder> findByCriteria(UserOrderCriteria criteria) {
		return userOrderDao.findByCriteria(criteria);
	}

	@Override
	public long findByCriteriaCount(UserOrderCriteria criteria) {
		return userOrderDao.findByCriteriaCount(criteria);
	}

	@Override
	public DatatableAjaxResponse<UserOrder> query(UserOrderCriteria criteria) {
		DatatableAjaxResponse<UserOrder> dar = new DatatableAjaxResponse<UserOrder>();
		
		long totalRecord = findByCriteriaCount(criteria);
		
		dar.setRecordsTotal(totalRecord);
		dar.setRecordsFiltered(totalRecord);
		dar.setData(findByCriteria(criteria));
		
		return dar;
	}

}
