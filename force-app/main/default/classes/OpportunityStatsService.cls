public with sharing class OpportunityStatsService {
    public class OpportunitySummary {
        @AuraEnabled public Decimal totalAmount;
        @AuraEnabled public Integer totalOpportunityCount;
        @AuraEnabled public Integer closedWonCount;
        @AuraEnabled public Integer openOpportunityCount;
        @AuraEnabled public Decimal averageDealSize;
        
		//contructor of this class
        public OpportunitySummary() {
            this.totalAmount = 0;
            this.totalOpportunityCount = 0;
            this.closedWonCount = 0;
            this.openOpportunityCount = 0;
            this.averageDealSize = 0;
        }
    }

    @AuraEnabled(cacheable=true)
    public static OpportunitySummary getOpportunitySummary(Id accountId) {
        OpportunitySummary result = new OpportunitySummary();

        if (accountId == null) {
            return result;
        }

        AggregateResult[] aggTotal = [
            SELECT SUM(Amount) totalAmount, COUNT(Id) totalCount
            FROM Opportunity
            WHERE AccountId = :accountId
        ];

        if (!aggTotal.isEmpty()) {
            Decimal sumAmt = (Decimal) aggTotal[0].get('totalAmount');
            if (sumAmt == null) sumAmt = 0;
            result.totalAmount = sumAmt;

            Decimal totalCountDec = (Decimal) aggTotal[0].get('totalCount');
            result.totalOpportunityCount = (totalCountDec == null) ? 0 : totalCountDec.intValue();
        }

        AggregateResult[] aggClosedWon = [
            SELECT COUNT(Id) closedWonCount
            FROM Opportunity
            WHERE AccountId = :accountId
              AND IsWon = true
        ];
        if (!aggClosedWon.isEmpty()) {
            Decimal closedDec = (Decimal) aggClosedWon[0].get('closedWonCount');
            result.closedWonCount = (closedDec == null) ? 0 : closedDec.intValue();
        }

        AggregateResult[] aggOpen = [
            SELECT COUNT(Id) openCount
            FROM Opportunity
            WHERE AccountId = :accountId
              AND IsClosed = false
        ];
        if (!aggOpen.isEmpty()) {
            Decimal openDec = (Decimal) aggOpen[0].get('openCount');
            result.openOpportunityCount = (openDec == null) ? 0 : openDec.intValue();
        }

        if (result.totalOpportunityCount > 0) {
            result.averageDealSize = (result.totalAmount == null) ? 0 : (result.totalAmount / result.totalOpportunityCount);
        } else {
            result.averageDealSize = 0;
        }

        return result;
    }
}