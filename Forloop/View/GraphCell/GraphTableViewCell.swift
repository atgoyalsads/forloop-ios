//
//  GraphTableViewCell.swift
//  BahrainSportDay2019
//
//  Created by admin on 31/01/19.
//  Copyright © 2019 Tecorb. All rights reserved.
//
//ScrollableGraphViewDataSource
import UIKit
//import ScrollableGraphView
import Charts


class GraphTableViewCell: UITableViewCell,ChartViewDelegate {
    @IBOutlet weak var graphView: BarChartView!

    @IBOutlet weak var lineChartViewContainer: UIView!

//var graphView:ScrollableGraphView!
    let linePlotingIndentifier = "line"
    let barPlotingIndentifier = "bar"
    lazy var data: [Double] = []
    lazy var labels: [String] = []
    var type:String = "monthly"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //createDotGraph(self.lineChartViewContainer.frame)
        graphView.delegate = self

        self.setChart()
        self.setGraph()
        self.updateGraph(type: type)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        self.updateGraph(type: type)
    }
    
    func updateGraph(type:String) {
       // createDotGraph(self.lineChartViewContainer.frame)
        print("label>>\(labels)")
        print("label>>\(data)")
        self.type = type
        graphView.delegate = self
        graphView.fitScreen()
        self.setChart()
        self.setGraph()
    }
    
    
    
    func setChart() {
        
        graphView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        
        if (self.labels.count != 0) || (self.data.count != 0) {
            
            
            for i in 0..<labels.count
            {
                let dataEntry = BarChartDataEntry(x: Double(i), y: self.data[i])
                
                dataEntries.append(dataEntry)
            }
            
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        
        
        let dataSets: BarChartDataSet = chartDataSet
        
        chartDataSet.colors = [appColor.appGreenColor]//[UIColor(red: 0/255, green: 161/255, blue: 155/255, alpha: 1)]
        chartDataSet.drawValuesEnabled = false
        
        
        let chartData = BarChartData(dataSet: dataSets)
        
        let groupSpace = 0.5
        let barSpace = 0.04
        let barWidth = 0.12
        // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
        
        let groupCount = self.labels.count
        let startYear = 0
        
        
        chartData.barWidth = barWidth;
        graphView.xAxis.axisMinimum = Double(startYear)
        let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
        graphView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
        graphView.data = chartData
        
        //background color
        graphView.backgroundColor = UIColor.white
        
        //chart animation
        graphView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .linear)
        graphView.notifyDataSetChanged()

        
    }
    func setGraph(){
        graphView.noDataText = "You need to provide data for the chart."
        graphView.chartDescription?.text = ""
        if type == "yearly"{
            self.graphView.setVisibleXRange(minXRange: 0.0, maxXRange: 20.0)

        }else{
            self.graphView.setVisibleXRange(minXRange: 0.0, maxXRange: 5.0)

        }
        graphView.setExtraOffsets(left: 10.0, top: 0.0, right: 0.0, bottom: 0.0)

        graphView.pinchZoomEnabled = false
        graphView.drawBarShadowEnabled = false
        graphView.drawGridBackgroundEnabled = false
        graphView.highlightPerTapEnabled = false
        graphView.highlightFullBarEnabled = false
        graphView.highlightPerDragEnabled = false
        //graphView.setTouchEnabled = false
        graphView.dragEnabled = true
        graphView.setScaleEnabled(true);
        graphView.doubleTapToZoomEnabled = false
        
        //legend
        let legend = graphView.legend
        legend.enabled = false
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = true
        legend.yOffset = 0.0;
        legend.xOffset = 0.0;
        legend.yEntrySpace = 0.0;
        
        let xaxis = graphView.xAxis
        // xaxis.valueFormatter = axisFormatDelegate
        xaxis.drawGridLinesEnabled = false
        
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = false
        xaxis.spaceMin = 0.0

        xaxis.granularity = 1

        xaxis.axisMinimum = -0.1
        xaxis.axisMaximum = Double(self.labels.count)
        xaxis.valueFormatter = IndexAxisValueFormatter(values:self.labels)
        xaxis.axisLineColor = appColor.lightGray
        xaxis.axisLineWidth = 3.0
        
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = graphView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = Double("USD$") ?? 0 + 0
        yaxis.drawGridLinesEnabled = true
        yaxis.drawAxisLineEnabled = true
        yaxis.labelCount = 5
        graphView.rightAxis.enabled = false
        graphView.leftAxis.enabled = true

        
        
        
        

        //axisFormatDelegate = self
    }

    
    
    
    
    
    
    
    
    /////////////////////////
    
//    var graphConstraints = [NSLayoutConstraint]()
//
//    private func setupConstraints() {
//        self.graphView.translatesAutoresizingMaskIntoConstraints = false
//        graphConstraints.removeAll()
//
//        let topConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.lineChartViewContainer, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
//        let rightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self.lineChartViewContainer, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
//        let bottomConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.lineChartViewContainer, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
//        let leftConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.lineChartViewContainer, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0)
//        //let heightConstraint = NSLayoutConstraint(item: self.graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
//
//        graphConstraints.append(topConstraint)
//        graphConstraints.append(bottomConstraint)
//        graphConstraints.append(leftConstraint)
//        graphConstraints.append(rightConstraint)
//        //graphConstraints.append(heightConstraint)
//        self.lineChartViewContainer.addConstraints(graphConstraints)
//    }
//
//
//
//    // ScrollableGraphViewDataSource
//    // #############################
//
//    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
//        switch(plot.identifier) {
//        case linePlotingIndentifier:
//            return data[pointIndex]
//        case barPlotingIndentifier:
//            return data[pointIndex]
//        default:
//            return 0
//        }
//    }
//
//    func label(atIndex pointIndex: Int) -> String {
//        return self.labels[pointIndex]
//    }
//
//    func numberOfPoints() -> Int {
//        return data.count
//    }
//
//
//    func createDotGraph(_ frame: CGRect)  {
//        if self.graphView == nil{
//            graphView = ScrollableGraphView(frame: frame, dataSource: self)
//        }else{
//            graphView.removeFromSuperview()
//            graphView = ScrollableGraphView(frame: frame, dataSource: self)
//        }
//
//        let barPlot = BarPlot(identifier: "bar")
//        barPlot.barWidth = 5.0
//        barPlot.barLineWidth = 0
//        barPlot.barLineColor = .clear
//        barPlot.barColor = redColor
//        barPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
//        barPlot.animationDuration = 0.1
//
//        // Setup the reference lines
//        let referenceLines = ReferenceLines()
//        //        referenceLines.referenceLineLabelFont = UIFont.init(name: "OpenSans-Semibold", size: 12.0)!
//        referenceLines.referenceLineColor = UIColor.lightGray //.withAlphaComponent(0.2)
//        referenceLines.referenceLineLabelColor = UIColor.black
//        referenceLines.dataPointLabelColor = UIColor.black.withAlphaComponent(1.0)
//        referenceLines.referenceLineUnits = "Steps"
//        //        referenceLines.dataPointLabelFont = UIFont.init(name: "OpenSans-Semibold", size: 12.0)!
//
//        // Setup the graph
//        graphView.backgroundFillColor = UIColor.white
//        graphView.shouldAnimateOnStartup = true
//
//        graphView.dataPointSpacing = 40
//
//        graphView.shouldRangeAlwaysStartAtZero = true
//        graphView.leftmostPointPadding = 50
//        graphView.rangeMin = 0
//        if let max = data.max(){
//            graphView.rangeMax = (max > 5.0) ? max  : 5.0
//        }
//
//        // Add everything
//        graphView.addPlot(plot: barPlot)
//        graphView.addReferenceLines(referenceLines: referenceLines)
//
//        self.lineChartViewContainer.addSubview(graphView)
//        self.setupConstraints()
//        //return graphView
//    }
    
}
