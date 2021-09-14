/Setting to change the space above and below the y bounds.
.glob.yBuffer: 2;
.glob.dict:`Month`Week`Day`Hour`Minute!(2628000;604800;86400;3600;60); / Dictionary giving number of seconds in each range type

/Generate some faux market trades using Brownian motion
gen_marketTrades: {[num]
    :marketTrades:: update price:{max(abs -0.5+x+y;5.0)}\[first price; count[i]?1.0] from 
                        `time xasc ([] time:(.z.d-30)+num?15D00:00:00; 
                        sym:num#`AAA; 
                        qty:1000*1+num?10;
                        price:num#25.0)
    };

/Generate some random trades based on the market trades
gen_trades: {[]
    numRows:min(first 4 + 1?25; `int$0.01 * count marketTrades);
    if[not 0= numRows mod 2; numRows +: 1];
    :trades::`time xasc update side:{0N?`B`S} tradeid by tradeid from 
        (update time+count[i]?00:00:00.1,
            price:price + 0.001 - count[i]?0.002,
            tradeid:neg[count[i]]?raze 2#enlist string 1 + til count[i] div 2 
            from numRows?marketTrades) 
 };

.api.aggregateOHLC:{ [tab]
    num:500;
    $[num < count tab;
        select open:first price, close:last price, high:max price, low:min price by time:`timestamp$(exec (max[time] - min time) % num-1 from tab) xbar time from tab;
        select high:max price, low:min price, open:first price, close:last price by time:time.date+time.second from tab]
 };

/Calculate the time steps for the bigger slider. This is configured to be in 1 hour steps, but this can be changed by adjusting the 1 * 60 * 60 part. (60 seconds * 60 minutes * 1 hour)
/The number after 'c:' needs to be adjusted also, to give the number of segments per day (1 hour segments mean 24 segments per day)
macroSliderQuery:{ ([] time:(`timestamp$(c+1)#first l) + (1 * 60 * 60 * 1000000000) * til 1+c:24*count l:exec distinct time.date from marketTrades) };

microSliderQuery:{ []
    ([]nums:1+til 360)
 };

/`startTime`rangeType`rangeNum set' .debug.ggPlotQuery
ggPlotQuery:{ [startTime; rangeType; rangeNum]
    .debug.ggPlotQuery:(startTime; rangeType; rangeNum);
    num:rangeNum*.glob.dict[rangeType]*1000000000;
    range:(startTime-num;startTime+num);
    cndl:update gain: close > open from 0!.api.aggregateOHLC[select from marketTrades where time within (range[0]; range[1])];
    trds:getTrades[marketTrades; trades; range[0]; range[1]; reverse value exec .glob.yBuffer+max high, (min low)-.glob.yBuffer from cndl];
    
    layers: ( 
        candlestick[cndl];
        tradeLines[trds]);
    if[count trds; layers:layers,bubbles[trds]];
    if[count labs: labels[trds]; layers: layers,labs];
    
    .gg.dash.go
        .qp.theme[.gg.theme.dark]
        .qp.theme[``labels`axis_tick_label_angle_x`axis_tick_label_anchor_x!(::;`x`y!("Time";"Price");0;`left)]
        .qp.title["Trades / Market Trades"]
        .qp.stack layers
 };

candlestick : { 
    fillscale : .gg.scale.colour.cat 01b!(.gg.colour.Red; .gg.colour.Green);
    xbreaks: first each 20 0N#asc distinct x`time;
    ybreaks:(distinct 5 xbar first each 45 0N# asc distinct x`high);
    .qp.theme[enlist[`legend_use]!enlist 0b]
    .qp.stack (
        // low/high - line
        .qp.segment[x; `time; `high; `time; `low]
            .qp.s.aes[`fill; `gain]
            , .qp.s.scale[`fill; .gg.scale.colour.cat 01b!(.gg.colour.White; .gg.colour.White)]
            , .qp.s.scale[`x; .gg.scale.breaks[xbreaks] .gg.scale.format[.gg.fmt.datetime] .gg.scale.timestamp]
            /, .qp.s.scale[`y; .gg.scale.breaks[ybreaks] .gg.scale.limits[$[0w ~ first l:reverse value exec .glob.yBuffer+max high, (min low)-.glob.yBuffer from x; 0 0f; l]] .gg.scale.linear]
            , .qp.s.geom[``size!(::; 1)];
        // open/close - bar
        .qp.interval[x; `time; `open; `close]
            .qp.s.aes[`fill; `gain]
            , .qp.s.scale[`fill; fillscale]
            , .qp.s.geom[``gap!(::; 0)])
 };

bubbles:{ 
    fillscale : .gg.scale.colour.cat `S`B!(.gg.colour.Red; .gg.colour.Blue);
    alphascale : .gg.scale.alpha[0;150];
    
    enlist .qp.theme[enlist[`legend_use]!enlist 0b]
    .qp.stack (   
    .qp.point[x;`startX;`startY] 
        .qp.s.aes[`alpha`fill`colour;`startVis,2#`$"Start Side"]
        , .qp.s.scale[`fill; fillscale]
        , .qp.s.scale[`colour; fillscale ]
        , .qp.s.geom[``size!(::; 6)];
    .qp.point[x;`endX;`endY] 
        .qp.s.aes[`alpha`fill`colour;`endVis,2#`$"End Side"]
        , .qp.s.scale[`fill; fillscale]
        , .qp.s.scale[`colour; fillscale ]
        , .qp.s.geom[``size!(::; 6)])
 };

tradeLines:{ 
    fillscale : .gg.scale.colour.cat `S`B!(.gg.colour.Red; .gg.colour.Blue);
    .qp.theme[enlist[`legend_use]!enlist 0b]
    .qp.segment[x; `startX; `startY; `endX; `endY]
        .qp.s.aes[`fill; `$"Start Side"]
        , .qp.s.scale[`fill; fillscale]
 };

labels: {
    /Labels need to show trade size and profit
    res: ();
    if[count select from x where endVis = 150; res:res, enlist .qp.text[select from x where endVis = 150; `endX; `endY; `Profit]
        .qp.s.geom[`offsetx`offsety`fill! (10;-10;.gg.colour.Yellow)]];
    if[count select from x where startVis = 150; res: res, enlist .qp.text[select from x where startVis = 150; `startX; `startY; `$"Trade Size"]
        .qp.s.geom[`offsetx`offsety`fill! (10;-10;.gg.colour.White)]];
    res
 };

getTrades: { [mt; t; microStartTime; microEndTime; lims]
    data:update startY:price from select from t where tradeid in exec distinct tradeid from t where (time within (microStartTime; microEndTime)) or ((microStartTime>(first;time) fby tradeid) and (microStartTime<(last;time) fby tradeid)) or (lims[0]>(first;price) fby tradeid) and (lims[1]<(first;price) fby tradeid) or (lims[0]>(last;price) fby tradeid) and (lims[1]<(last;price) fby tradeid);
    /Set up the table rows, store start and end points, as well as initialise calculated start and end points with original values.
    d1:0!select startX:first time, startY:first price, endX:last time, endY:last price, origSX:first time, 
        origSY:first price, origEX:last time, origEY:last price, startSide:first side, endSide:last side,
        profit:last price - first price, tradeSize:abs[first qty - last qty] by tradeid:`$tradeid from data;
    
    /Working on start point first: calculate x and store y pos for points that are outside the upper and lower y-axis bounds.
    /This will set the x and y coords for the starting point for these rows.
    d1:update startX:`timestamp$getX[origSX;origEX;origSY;origEY;?[origSY>lims[1];lims[1];?[origSY<lims[0];lims[0];origSY]]],
        startY:?[origSY>lims[1];lims[1];?[origSY<lims[0];lims[0];origSY]] from d1 where (origSY<lims[0]) or (origSY>lims[1]);
    /Calculate the y and store x for points that are before the minimum x bound. This picks up and fixes cases where the starting point
    /was both before the minimum x and outside the y bounds. Uses the stored x value from above to check which are outside the bounds.
    d1:update startY:getY[origSX;origEX;origSY;origEY;?[origSX<microStartTime;microStartTime;origSX]], 
        startX:?[origSX<microStartTime;microStartTime;origSX] from d1 where (startX < microStartTime) or (microEndTime < endX);
    
    /Same process as above, but for the end points.
    d1:update endX:`timestamp$getX[origSX;origEX;origSY;origEY;?[origEY>lims[1];lims[1];?[origEY<lims[0];lims[0];origEY]]],
        endY:?[origEY>lims[1];lims[1];?[origEY<lims[0];lims[0];origEY]] from d1 where (origEY<lims[0]) or (origEY>lims[1]);
    d1:update endY:getY[origSX;origEX;origSY;origEY;?[origEX>microEndTime;microEndTime;origEX]], 
        endX:?[origEX>microEndTime;microEndTime;origEX] from d1 where (endX > microEndTime) or (microStartTime > endX);
    /Rename the columns and order them so they display nicely in the tooltip.
    ?[d1;();0b;((`$("Trade ID"; "Time Entered"; "Price Entered"; "Time Exited"; "Price Exited"; "Profit"; "Trade Size"; "Start Side"; "End Side")),`startX`startY`endX`endY`startVis`endVis)!(`tradeid`origSX`origSY`origEX`origEY`profit`tradeSize`startSide`endSide`startX`startY`endX`endY,((?;(=;`origSX;`startX);150;0);(?;(=;`origEX;`endX);150;0)))]
 };

/Function to calculate x pos on a line for given y
getX:{[x0; x1; y0; y1; y]     
    m: (y1 - y0) % (x1 - x0); 
    ((y - y0) % m) + x0 
 };
/Function to calculate y pos on a line for given x
getY:{[x0; x1; y0; y1; x] 
    m: (y1 - y0) % (x1 - x0);
    (m * (x - x0)) + y0
 };

gen_marketTrades[1000000];
gen_trades[];

