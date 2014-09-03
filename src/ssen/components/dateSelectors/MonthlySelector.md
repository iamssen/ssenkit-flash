```xml
<DropdownMonthlySelector selectedMonth="201405">
    <limiter>
        <RangedMonthlyLimiter from="201008" to="201509" />
    </limiter>
</DropdownMonthlySelector>
<!-- MonthlySelector가 판이 되고, DropdownMonthlySelector는 Anchor가 된다 -->

<DropdownWeekSelector selectedWeek="201534">
    <limiter>
        <RangedWeekLimiter from="201024" to="201534" />
    </limiter>
</DropdownWeekSelector>
<!-- WeekSelector가 판이 되고, DropdownWeekSelector는 Anchor가 된다 -->
```