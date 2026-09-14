import os
import tkinter as tk
from tkinter import ttk, messagebox, PhotoImage, StringVar
from tkcalendar import DateEntry
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
import mplcursors 
import numpy as np
from alpha_vantage.timeseries import TimeSeries
import csv
from PIL import Image,ImageTk
import pytz
from datetime import datetime
from dotenv import load_dotenv

load_dotenv()  # reads ALPHAVANTAGE_API_KEY from .env next to this file

class StockApp:
    def __init__(self, root):
        self.root = root
        self.root.geometry("1200x1000")#size of Window
        self.root.title("InvestInsight")
        self.symbols = []
        #Initialize reset_flag to True
        self.reset_flag = True

        file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "assets", "800x600.jpg")
        self.bg = ImageTk.PhotoImage(Image.open(file))

        #bg_image = tk.Label(root, bg=self.color)
        #bg_image.place(relheight=1, relwidth=1)
        

        self.visualization_var = StringVar()
        self.color ='#e49b0f'

        bg_image = tk.Label(root, bg=self.color)
        bg_image.place(relheight=1, relwidth=1)

        header = tk.Label(root, text='InvestInsight', height=2, font=('Arial', 20, 'bold'), bg='#0f4d92', fg='white')
        header.place(x=100, y=30, anchor='center')

        # Fetch stock symbols and create widgets
        self.symbols = self.fetch_symbols()
        #print("Fetched symbols:", self.symbols)  # Debug print
        self.create_widgets(self.symbols)
    
    def fetch_symbols(self):
    # Open the file in read mode
        with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "Symbol.txt"), "r") as symbol_file:
        # Read all lines from the file
          read_symbols = symbol_file.readlines()
    
    # Strip any extra whitespace and add each symbol to the list
        companies = [line.strip() for line in read_symbols]
    
        return companies
    #Print time stamp
    def time_stamp(self):
        TimeZone = pytz.timezone('America/Toronto')
        utc = datetime.now(pytz.utc)
        local_time = utc.astimezone(TimeZone)
        self.time_label.config(text=f"Current Time: {local_time},\n Students: Pitchporn & Kifah")
        print("\nTime stamp\n",local_time)
        
        
# all the widgets in application
    def create_widgets(self, Companies):
        companyLabel1 = tk.Label(self.root, text='Select Company', bg=self.color)
        companyLabel1.place(x=110, y=80, anchor='center')
        self.dropCompany1 = ttk.Combobox(self.root, values=Companies)
        self.dropCompany1.place(x=260, y=80, anchor='center')

        companyLabel2 = tk.Label(self.root, text='Select Company (Optional)',bg=self.color)
        companyLabel2.place(x=110, y=105, anchor='center')
        self.dropCompany2 = ttk.Combobox(self.root, values=Companies)
        self.dropCompany2.place(x=260, y=105, anchor='center')

        companyLabel3 = tk.Label(self.root, text='Select Company (Optional)',bg=self.color)
        companyLabel3.place(x=110, y=130, anchor='center')
        self.dropCompany3 = ttk.Combobox(self.root, values=Companies,)
        self.dropCompany3.place(x=260, y=130, anchor='center')

        s_date_label = tk.Label(self.root, text='Start Date:',bg=self.color)
        s_date_label.place(x=80, y=155, anchor='e')
        self.s_date = DateEntry(self.root, selectmode='day')
        self.s_date.place(x=130, y=155, anchor='center')

        e_date_label = tk.Label(self.root, text='End Date:',bg=self.color)
        e_date_label.place(x=180, y=155, anchor='w')
        self.e_date = DateEntry(self.root, selectmode='day')
        self.e_date.place(x=285, y=155, anchor='center')

        r_button1 = tk.Radiobutton(self.root, text='Stock Price & Moving Average',bg=self.color, variable=self.visualization_var, value='visual1')
        r_button1.place(x=30, y=180, anchor='w')

        r_button2 = tk.Radiobutton(self.root, text='Monthly Overview',bg=self.color, variable=self.visualization_var, value='visual2')
        r_button2.place(x=30, y=200, anchor='w')

        r_button3 = tk.Radiobutton(self.root, text='ROI Analysis',bg=self.color, variable=self.visualization_var, value='visual3')
        r_button3.place(x=30, y=220, anchor='w')

        r_button4 = tk.Radiobutton(self.root, text='Risk Analysis',bg=self.color, variable=self.visualization_var, value='visual4')
        r_button4.place(x=30, y=240, anchor='w')

        r_button5 = tk.Radiobutton(self.root, text='Trend Analysis',bg=self.color, variable=self.visualization_var, value='tables5')
        r_button5.place(x=30, y=260, anchor='w')

        reset_button = tk.Button(self.root, text='Reset', command=self.reset_form, activebackground='#228b22')
        reset_button.place(x=80, y=300, anchor='center')

        submit_button = tk.Button(self.root, text='Submit', command=self.on_submit, activebackground='#228b22')
        submit_button.place(x=150, y=300, anchor='center')
        
        # Add time stamp as alabel to the bottom
        self.time_label = tk.Label(self.root, text='Time Stamp:', bg=self.color)
        self.time_label.place(x=150, y=680, anchor='center')
        # Call the time stamp function to update the date happens once at the strat of the program
        self.time_stamp()
        
        frame_w= 800
        frame_h= 600
        self.visualization_frame = tk.Frame(root, width=frame_w, height=frame_h,background=self.color)
        self.visualization_frame.pack_propagate(False)
        self.visualization_frame.place(x=750, y=320, anchor='center')

        # Canvas to show visualization
        self.canvas = tk.Canvas(self.visualization_frame, width=frame_w-20, height=frame_h-20)
        self.canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        self.canvas.create_image( 0, 0, image = self.bg,  anchor = "nw") 

        #self.scroll_y = tk.Scrollbar(self.visualization_frame,orient=tk.VERTICAL,command=self.canvas.yview)
        #self.scroll_y.pack(side=tk.RIGHT, fill=tk.Y)
        #self.canvas.configure(yscrollcommand=self.scroll_y.set) #remove scrollbar?
   

        # Update the canvas scroll region
        #self.visualization_frame.update_idletasks()
        #self.canvas.config(scrollregion=self.canvas.bbox("all"))

    def get_stock_data(self,symbols, start_date, end_date):
    # Read the API key from the file
        API_Key = os.environ.get("ALPHAVANTAGE_API_KEY")
        if not API_Key:
            raise RuntimeError("Set ALPHAVANTAGE_API_KEY in a .env file (see .env.example) before running the app.")
        def daily_stock_data(symbol, API_Key):
        # Fetch daily stock data and put it in Pandas DataFrame format
          ts = TimeSeries(key=API_Key, output_format='pandas')
          data_stock, meta_data = ts.get_daily(symbol=symbol, outputsize='full')
          return data_stock

    # Convert string dates to pandas Timestamp
        start_date = pd.Timestamp(start_date)
        end_date = pd.Timestamp(end_date)
        stock_data = {}

        for symbol in symbols:
        # Fetch data using the API
            df = daily_stock_data(symbol, API_Key)
        
        # Filter data by date range
            filtered_df = df[(df.index >= start_date) & (df.index <= end_date)]
        
        # Optional: Clean column names if necessary
            filtered_df.columns = filtered_df.columns.str.split(' ').str[1]
        
        # Store filtered data
            stock_data[symbol] = filtered_df

        return stock_data
       
     #Find daily return for Risk Analysis function
    def calculate_daily_returns(self, stock_data):
        daily_returns = {}
    
    # Calculate the daily returns for each stock
        for symbol, df in stock_data.items():
        # Ensure 'open' and 'close' columns are in the dataframe
          if 'open' in df.columns and 'close' in df.columns:
            daily_return = ((df['close'] - df['open']) / df['open']) * 100
            daily_returns[symbol] = daily_return
            
        return daily_returns

       
     #Visualization 1

    def Plt_Stock_Closing_Price_Moving_Average(self,stock_data,include_SPY):
        window_size = 10
        #adjust size of output
        plt.style.use('dark_background')
        fig, ax = plt.subplots(figsize=(8, 6)) #8,6

        for symbol, df in stock_data.items():
            if symbol == 'SPY' and not include_SPY:
               continue
            ax.plot(df.index, df['close'], label=f'{symbol} Close Price')

         # Calculate and plot the moving average
            moving_avg = df['close'].rolling(window=window_size).mean()
            if not moving_avg.dropna().empty:  # Check if moving_avg has valid data
               ax.plot(moving_avg.index, moving_avg.values, linestyle='--', label=f'{symbol} {window_size}-Day MA')
       
        ax.set_xlabel('Date')
        ax.set_ylabel('Price ($)')
        ax.set_title('Stock Closing Prices and the Closing Price Moving Average')
        ax.legend()
        ax.grid(False)

        return fig
    
#visualization2
    def Monthly_OverView(self,stock_data, include_SPY):
    
    # Create a Matplotlib figure
    #adjust the size
       fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8,6.5))

    # Calculate the avg for monthly close and open price
       Avg_data = {}
       for symbol in stock_data:
            if symbol == 'SPY' and not include_SPY:
                   continue
            Avg_data[symbol] = stock_data[symbol].resample('M')['close'].mean()
            Avg_data[symbol].index = Avg_data[symbol].index.to_period('M').to_timestamp()
            Avg_data[symbol].name = 'Average Monthly Closing Price'

    # Plot the Average monthly price
       for symbol, avg_series in Avg_data.items():
          if symbol == 'SPY' and not include_SPY:
             continue
          ax1.plot(avg_series.index, avg_series.values, label=symbol, marker='o')
          ax1.set_title('Average Monthly Close Prices')
          ax1.set_xlabel('Month')
          ax1.set_ylabel('Price (USD $)')
          ax1.legend()
          ax1.grid(False)

    # Calculate the total monthly trade volume
          Monthly_Trade_volum = {}
          for symbol in stock_data:
              if symbol == 'SPY' and not include_SPY:
               continue
              Monthly_Trade_volum[symbol] = stock_data[symbol].resample('M')['volume'].sum()
              Monthly_Trade_volum[symbol].index = Monthly_Trade_volum[symbol].index.to_period('M').to_timestamp()
              Monthly_Trade_volum[symbol] = Monthly_Trade_volum[symbol] / 1000000000
              Monthly_Trade_volum[symbol].name = 'Total_volume(Shares)'

    # Plot the total monthly trade volume
          for symbol, volume_series in Monthly_Trade_volum.items():
              if symbol == 'SPY' and not include_SPY:
               continue
              ax2.plot(volume_series.index, volume_series.values, label=symbol, marker='o')
              ax2.set_title('Total Monthly Trade Volume of Stocks')
              ax2.set_xlabel('Date')
              ax2.set_ylabel('Total Volume (Billions)')
              ax2.legend()
              ax2.grid(False)

       return fig
    
#visualization3
    def ROI_Analysis(self, stock_data, include_SPY):
        daily_returns_fig = None
        monthly_returns_fig = None
    # Daily Returns Plot
        daily_returns_fig, ax1 = plt.subplots(figsize=(8,2.5))#size of the output1
        self.daily_return = {} #create dict so it can't be used outside this function
        for symbol, df in stock_data.items():
            if symbol == 'SPY' and not include_SPY:
               continue
            self.daily_return = ((df['close'] - df['open']) / df['open']) * 100
            ax1.plot(self.daily_return.index, self.daily_return.values, label=symbol)
        ax1.set_title('Daily Return on Investment')
        ax1.set_xlabel('Date')
        ax1.set_ylabel('Daily Return (%)')
        ax1.legend()
        ax1.grid(False)
        mplcursors.cursor(ax1, hover=True)  # Add cursor for interactive tooltips

    # Monthly Returns Plot
        monthly_returns_fig, ax2 = plt.subplots(figsize=(8, 2.5))#size of the output2
        for symbol, df in stock_data.items():
            if symbol == 'SPY' and not include_SPY:
               continue
            monthly_return = ((df['close'].resample('M').last() - df['open'].resample('M').first()) /
                           df['open'].resample('M').first()) * 100
        monthly_return.index = monthly_return.index.to_period('M').to_timestamp()
        ax2.plot(monthly_return.index, monthly_return.values, label=symbol)
        ax2.set_title('Monthly Return on Investment')
        ax2.set_xlabel('Month')
        ax2.set_ylabel('Monthly Return (%)')
        ax2.legend()
        ax2.grid(False)
        mplcursors.cursor(ax2, hover=True)  # Add cursor for interactive tooltips
        
        daily_return = ((df['close'] - df['open']) / df['open']) * 100
        self.daily_return = daily_return
        

        return daily_returns_fig, monthly_returns_fig
        
        

#visualization 4
    def Risk_Analysis(self, stock_data, daily_return):
    # Calculate Beta
      beta = {}
      max_start_dates = {}

    # Determine the earliest common date for alignment
      for symbol in stock_data:
        max_start_dates[symbol] = min(daily_return['SPY'].index.min(), daily_return[symbol].index.min())
    
      for symbol in stock_data:
        # Filter data to include only dates from max_start_date onwards
        filtered_spy = daily_return['SPY'][daily_return['SPY'].index >= max_start_dates[symbol]]
        filtered_stock = daily_return[symbol][daily_return[symbol].index >= max_start_dates[symbol]]
        
        # Calculate covariance and variance
        covariance = np.cov(filtered_stock, filtered_spy)[0, 1]
        variance_spy = np.var(filtered_spy)
        beta[symbol] = covariance / variance_spy

      # Create Interactive table to Compare beta
      beta_df = pd.DataFrame(list(beta.items()), columns=['Stock', 'Beta'])
      volatility = []
      for symbol in beta_df['Stock']:
        if symbol != 'SPY':
            if beta[symbol] > 1:
                volatility.append('More Volatile')
            elif beta[symbol] < 1:
                volatility.append('Less Volatile')
        else:
            volatility.append('Similar to Market')
      beta_df['Volatility'] = volatility
    
     # Create the interactive diagram for volatility
      window_size = 30
      volatility = {}
      for symbol, df in stock_data.items():
        # Calculate rolling standard deviation of daily returns
        daily_return_series = daily_return[symbol]
        volatility[symbol] = daily_return_series.rolling(window=window_size).std() * np.sqrt(252)

      fig_vola, ax_vola = plt.subplots(figsize=(8, 6))
      for symbol, vol in volatility.items():
        ax_vola.plot(vol.index, vol.values, label=f'{symbol} Rolling 1-Month Volatility')
      ax_vola.set_title('Volatility Comparison: All Stocks')
      ax_vola.set_xlabel('Date')
      ax_vola.set_ylabel('Volatility (%)')
      ax_vola.legend()
      ax_vola.grid(True)
      mplcursors.cursor(ax_vola, hover=True)  # Add cursor for interactive tooltips

    # Interactive table with dark theme
      fig_beta, ax_beta = plt.subplots(figsize=(8, 4))
      ax_beta.axis('off')
      mpl_table = ax_beta.table(cellText=beta_df.values, colLabels=beta_df.columns, cellLoc='center', loc='center', 
                              rowColours=['#1f1f1f']*len(beta_df), colColours=['#333333']*len(beta_df.columns),
                              cellColours=[['#1f1f1f']*len(beta_df.columns)]*len(beta_df), 
                              edges='closed')

      mpl_table.auto_set_font_size(False)
      mpl_table.set_fontsize(10)
      mpl_table.scale(1.2, 1.2)
      mplcursors.cursor(ax_beta, hover=True)  # Add cursor for interactive tooltips

      return fig_beta, fig_vola

    
#tables5
    def Frequency_Trends(self, stock_data, include_SPY):
    # Define dictionaries to store results
      self.monthly_high = {}
      self.monthly_low = {}

    # Calculate monthly highs and lows
      for symbol in stock_data:
          if symbol == 'SPY' and not include_SPY:
            continue
        # Calculate monthly highs
          self.monthly_high[symbol] = stock_data[symbol].resample('M')['high'].agg(['max', 'idxmax'])
        # Calculate monthly lows
          self.monthly_low[symbol] = stock_data[symbol].resample('M')['low'].agg(['min', 'idxmin'])

        # Adding additional columns for day of the week and month
          self.monthly_high[symbol]['day_of_week'] = self.monthly_high[symbol]['idxmax'].dt.day_name()
          self.monthly_high[symbol]['month_name'] = self.monthly_high[symbol]['idxmax'].dt.month_name()
          self.monthly_low[symbol]['day_of_week'] = self.monthly_low[symbol]['idxmin'].dt.day_name()
          self.monthly_low[symbol]['month_name'] = self.monthly_low[symbol]['idxmin'].dt.month_name()

    # Prepare data for Treeview
      high_tables = {}
      low_tables = {}
      

      for symbol in stock_data:
        if symbol == 'SPY' and not include_SPY:
            continue
        high_df = self.monthly_high[symbol].reset_index().rename(columns={
            'idxmax': 'Date of the Monthly Highest Price',
            'max': 'Highest Price of the Month'
        })
        low_df = self.monthly_low[symbol].reset_index().rename(columns={
            'idxmin': 'Date of the Monthly Lowest Price',
            'min': 'Lowest Price of the Month'
        })

        high_df['Date of the Monthly Highest Price'] = high_df['Date of the Monthly Highest Price'].dt.strftime('%Y-%m-%d')
        low_df['Date of the Monthly Lowest Price'] = low_df['Date of the Monthly Lowest Price'].dt.strftime('%Y-%m-%d')

        high_df = high_df[['Date of the Monthly Highest Price', 'month_name', 'Highest Price of the Month', 'day_of_week']]
        low_df = low_df[['Date of the Monthly Lowest Price', 'month_name', 'Lowest Price of the Month', 'day_of_week']]

         # Determine month with the highest single price and lowest single price
        highest_single_high_month = high_df.loc[high_df['Highest Price of the Month'].idxmax()]['month_name']
        highest_single_high_value = high_df['Highest Price of the Month'].max()

        lowest_single_low_month = low_df.loc[low_df['Lowest Price of the Month'].idxmin()]['month_name']
        lowest_single_low_value = low_df['Lowest Price of the Month'].min()

        # Create comments for highlights
        high_comments = (
          f"Month with the highest single high price: {highest_single_high_month} ({highest_single_high_value:.2f} dollars)\n"
          f"Most frequent day for highest prices: {self.monthly_high[symbol]['day_of_week'].mode()[0]}"
        )

        low_comments = (
          f"Month with the lowest single low price: {lowest_single_low_month} ({lowest_single_low_value:.2f} dollars)\n"
          f"Most frequent day for lowest prices: {self.monthly_low[symbol]['day_of_week'].mode()[0]}"
          )

        high_tables[symbol] = (high_df,high_comments)
        low_tables[symbol] = (low_df,low_comments)

      return high_tables, low_tables

#fucntion to create a pop-up window for fuction'Frequecy Trends' result
    def show_tables_popup(self, high_tables, low_tables):
      popup = tk.Toplevel(self.root)
      popup.title("Frequency Trends")
      popup.geometry("800x1200")  # Adjust size as needed

      # Create a canvas and scrollbar
      canvas = tk.Canvas(popup)
      scrollbar = tk.Scrollbar(popup, orient="vertical", command=canvas.yview)
      canvas.configure(yscrollcommand=scrollbar.set)
    # Pack scrollbar and canvas
      scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
      canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
    # Create a frame inside the canvas
      frame = tk.Frame(canvas)
      canvas.create_window((0, 0), window=frame, anchor='nw')

    # Update the canvas scroll region
      frame.update_idletasks()
      canvas.config(scrollregion=canvas.bbox("all"))

# Create and pack treeviews for high and low tables
      for symbol in high_tables: #Just so we have reference for symbol viriable
        # High Table
        high_label = tk.Label(frame, text=f"High Table - {symbol}", font=('Arial', 12, 'bold'))
        high_label.pack(anchor='w', padx=10, pady=5)
        high_df, high_comment = high_tables[symbol]  # Unpack the tuple
        high_tree = ttk.Treeview(frame, columns=list(high_df.columns), show='headings')
        for col in high_df.columns:
            high_tree.heading(col, text=col)
            high_tree.column(col, width=195, anchor='w')
        for _, row in high_df.iterrows():
            high_tree.insert('', 'end', values=row.tolist())
        high_tree.pack(side=tk.TOP, fill=tk.BOTH, expand=True, padx=10, pady=5)
        high_comment_label = tk.Label(frame, text=high_comment, justify=tk.LEFT)
        high_comment_label.pack(anchor='w', padx=10, pady=5)
        
        # Low Table
        low_label = tk.Label(frame, text=f"Low Table - {symbol}", font=('Arial', 12, 'bold'))
        low_label.pack(anchor='w', padx=10, pady=5)
        low_df, low_comment = low_tables[symbol]  # Unpack the tuple
        low_tree = ttk.Treeview(frame, columns=list(low_df.columns), show='headings')
        for col in low_df.columns:
            low_tree.heading(col, text=col)
            low_tree.column(col, width=195, anchor='w')
        for _, row in low_df.iterrows():
            low_tree.insert('', 'end', values=row.tolist())
        low_tree.pack(side=tk.TOP, fill=tk.BOTH, expand=True, padx=10, pady=5)
        low_comment_label = tk.Label(frame, text=low_comment, justify=tk.LEFT)
        low_comment_label.pack(anchor='w', padx=10, pady=5)

        # Add a separator between the high and low tables
        separator = tk.Frame(frame, height=2, bd=1, relief=tk.SUNKEN)
        separator.pack(fill=tk.X, padx=10, pady=5)

    # Update the canvas scroll region again to accommodate new widgets
      frame.update_idletasks()
      canvas.config(scrollregion=canvas.bbox("all"))

#fucntion to create a pop-up window for fuction'Risk Analysis' result
    def show_risk_analysis(self, fig_beta, fig_vola):
    # Create a new top-level window
      popup = tk.Toplevel(self.root)
      popup.title("Risk Analysis Results")

    # Create a frame for the canvas and scrollbars
      frame = tk.Frame(popup)
      frame.pack(fill=tk.BOTH, expand=True)

    # Create a canvas and scrollbar frame
      canvas = tk.Canvas(frame)
      scrollbar_y = tk.Scrollbar(frame, orient="vertical", command=canvas.yview)
      scrollbar_x = tk.Scrollbar(frame, orient="horizontal", command=canvas.xview)
    
    # Create a frame inside the canvas for the figures
      canvas_frame = tk.Frame(canvas)
    
    # Add the canvas and scrollbars to the frame
      canvas.create_window((0, 0), window=canvas_frame, anchor="nw")
      canvas.configure(yscrollcommand=scrollbar_y.set, xscrollcommand=scrollbar_x.set)

    # Pack the canvas and scrollbars
      canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
      scrollbar_y.pack(side=tk.RIGHT, fill=tk.Y)
      scrollbar_x.pack(side=tk.BOTTOM, fill=tk.X)
    
    # Add the figures to the canvas frame
      beta_canvas = FigureCanvasTkAgg(fig_beta, master=canvas_frame)
      beta_canvas.draw()
      beta_canvas.get_tk_widget().pack(side=tk.TOP, fill=tk.BOTH, expand=True)
    
      vola_canvas = FigureCanvasTkAgg(fig_vola, master=canvas_frame)
      vola_canvas.draw()
      vola_canvas.get_tk_widget().pack(side=tk.TOP, fill=tk.BOTH, expand=True)
    
    # Update the canvas scroll region
      canvas_frame.update_idletasks()
      canvas.config(scrollregion=canvas.bbox("all"))

    # Set the window size and make it resizable
      popup.geometry("800x600")
      popup.resizable(True, True)



#Handle all visualizations and tables
    def create_visualization(self, stock_data, include_SPY, visual_type):
    # Clear the visualization frame
        for widget in self.visualization_frame.winfo_children():
            widget.destroy()
    # Calculate daily returns
        daily_returns = self.calculate_daily_returns(stock_data)

       
#Visual1
        if visual_type == 'visual1':
           fig = self.Plt_Stock_Closing_Price_Moving_Average(stock_data,include_SPY)
          # fig = self.Plt_Stock_Closing_Price_Moving_Average(stock_data,)
        # Embed the matplotlib figure into the Tkinter frame
           canvas = FigureCanvasTkAgg(fig, master=self.visualization_frame)
           canvas.draw()
           canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True)
#Visual2
        elif visual_type == 'visual2':
           fig = self.Monthly_OverView(stock_data)
        # Embed the matplotlib figure into the Tkinter frame
           canvas = FigureCanvasTkAgg(fig, master=self.visualization_frame)
           canvas.draw()
           canvas.get_tk_widget().pack(fill=tk.BOTH, expand=True)
#Visual3
        elif visual_type == 'visual3':
          daily_fig, monthly_fig = self.ROI_Analysis(stock_data)

        # Embed daily returns plot
          if daily_fig:
             canvas_daily = FigureCanvasTkAgg(daily_fig, master=self.visualization_frame)
             canvas_daily.draw()
             canvas_daily.get_tk_widget().pack(fill=tk.BOTH, expand=True)

        # Embed monthly returns plot
          if monthly_fig:
             canvas_monthly = FigureCanvasTkAgg(monthly_fig, master=self.visualization_frame)
             canvas_monthly.draw()
             canvas_monthly.get_tk_widget().pack(fill=tk.BOTH, expand=True)
#Visual4
        elif visual_type == 'visual4':
              fig_beta, fig_vola = self.Risk_Analysis(stock_data, daily_returns)
              self.show_risk_analysis(fig_beta, fig_vola)
#tables5       
        elif visual_type == 'tables5':
             high_tables, low_tables = self.Frequency_Trends(stock_data)
             self.show_tables_popup(high_tables, low_tables)

        else:
          messagebox.showerror('Selection Error', 'Invalid visualization type')
    
#everything that happen when click submit
    def on_submit(self):
          #symbols list from customers input
          self.symbols = [self.dropCompany1.get(), self.dropCompany2.get(), self.dropCompany3.get()]
          self.symbols = [symbol for symbol in self.symbols if symbol]  # Remove empty selections

          start_date = self.s_date.get_date()
          end_date = self.e_date.get_date()

          if not self.symbols:
            messagebox.showerror('Input Error', 'Please select at least one company')
            return

          if not start_date or not end_date or start_date >= end_date:
            messagebox.showerror('Date Error', 'Please ensure all dates are selected and start date is before end date')
            return
         #Kifah
         #symbol list including SPY for risk analysis 
          self.symbols_with_spy = self.symbols.copy()  # Make a copy of user symbols list
          if 'SPY' not in self.symbols_with_spy:
             self.symbols_with_spy.append('SPY') 
             include_SPY=False
          else:
             include_SPY=True
          if self.reset_flag:
            self.stock_data = self.get_stock_data(self.symbols_with_spy, start_date, end_date)
            self.reset_flag= False   
            print("using new data")
          #kifah 
        # Clear previous visualizations
          for widget in self.visualization_frame.winfo_children():
            widget.destroy()
         #Determine the selected visualization type
          visual_type = self.visualization_var.get()
          self.create_visualization(self.stock_data,include_SPY, visual_type)
          
 
 # reset buntton function    
    def reset_form(self):
    # Reset dropdowns
      self.dropCompany1.set('')
      self.dropCompany2.set('')
      self.dropCompany3.set('')
    
    # Reset date entries to current date or default value
      self.s_date.set_date(pd.Timestamp.now().to_pydatetime().date())
      self.e_date.set_date(pd.Timestamp.now().to_pydatetime().date())
    
    # Reset radio buttons (deselect all)
      self.visualization_var.set('')
    # Kifah_ Set the reset flag to False as form has been reset
      self.reset_flag = True
    #Kifah  
    # Clear the visualization frame
      for widget in self.visualization_frame.winfo_children():
        widget.destroy()
        
   

        
      
    

if __name__ == "__main__":
    root = tk.Tk()
    app = StockApp(root)
    root.mainloop()

