package net.kadirderer.btc.service;

import net.kadirderer.btc.api.buyorder.BuyOrderService;
import net.kadirderer.btc.api.cancelorder.CancelOrderService;
import net.kadirderer.btc.api.marketdepth.MarketDepthResult;
import net.kadirderer.btc.api.marketdepth.MarketDepthService;
import net.kadirderer.btc.api.orderbook.OrderbookService;
import net.kadirderer.btc.api.queryaccountinfo.QueryAccountInfoResult;
import net.kadirderer.btc.api.queryaccountinfo.QueryAccountInfoService;
import net.kadirderer.btc.api.queryorder.QueryOrderService;
import net.kadirderer.btc.api.sellorder.SellOrderService;
import net.kadirderer.btc.config.ConfigMap;
import net.kadirderer.btc.db.dao.UserOrderDao;

import org.springframework.beans.factory.annotation.Autowired;

public abstract class AutoTradeThreadService {
	
	@Autowired
	private UserOrderDao userOrderDao;
	
	public abstract SellOrderService getSellOrderService();
	
	public abstract BuyOrderService getBuyOrderService();
	
	public abstract CancelOrderService getCancelOrderService();
	
	public abstract QueryOrderService getQueryOrderService();
	
	public abstract OrderbookService getOrderBookService();
	
	public abstract MarketDepthService getMarketDepthService();
	
	public abstract QueryAccountInfoService getQueryAccountInfoService();
	
	public abstract double getBtcBalanceMinimumLimit();
	
	public abstract double getCurrencyMinimumLimit();
	
	public abstract int getPlatformId();
	
	public abstract double getDeltaForTrade();
	
	public abstract int getPeriod();
	
	private boolean isFirstTime = true;
	
	public void autoTrade(String username) throws Exception {
		
		MarketDepthResult mdr = getMarketDepthService().getMarketDepth(username);
		double lowestAsk = mdr.getHighestBid() + ConfigMap.sellOrderDelta();
		double highestBid = mdr.getLowestAsk() - ConfigMap.buyOrderDelta();
		
		QueryAccountInfoResult qaiResult = getQueryAccountInfoService().queryAccountInfo(username);
		double btcBalance = qaiResult.getBtcBalance();
		double currencyBalance = qaiResult.getCurrencyBalance();
		
		if(currencyBalance > 0) {
			getBuyOrderService().buyOrder(username, highestBid, currencyBalance / highestBid);		
		}
		
		if(btcBalance > 0 && isFirstTime) {
			getSellOrderService().sellOrder(username, lowestAsk, btcBalance, 0);
		}
		
		isFirstTime = false;
	}

}
