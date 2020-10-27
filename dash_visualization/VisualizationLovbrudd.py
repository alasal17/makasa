import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
from dash.dependencies import Input, Output
import plotly.express as px
import plotly.graph_objects as go
import psycopg2
import os
import pathlib

#USER_NAME = os.environ['P_USER']
PASS = os.environ['P_PASS']
#HOST = os.environ[]
PORT = 5432

# Connection

try:
            connection = psycopg2.connect(
                user='student_kaja',
                password=PASS,
                host='ds-etl-academy.cgbivchwjzle.eu-west-1.rds.amazonaws.com',
                port=PORT,
                database='gp_makasa'
            )

            cursor = connection.cursor()


except Exception as e:
    print(e)

def data_from_fakta1():

    cursor.execute("""select sum(f.value_lovbrudd), å.år, l.lovbruddstype from star_schema.fakta_lovbrudd_1 f
    join star_schema.dim_lovbruddstyper l using(lovbrudds_id) 
    join star_schema.dim_år å using(år_id)
    group by l.lovbruddstype, å.år
    order by å.år asc;""")

    # cursor.execute("""select flo."Lovbrudd etterforsket" , å.år, dlo.lovbruddstype  from star_schema.fakta_lovbrudd_oslo flo
    #         join star_schema.dim_lovbruddstyper_oslo dlo using(lovbrudds_id)
    #         join star_schema.dim_år å using(år_id)
    #         order by å.år asc;""")

    # Get one data from database
    data_df = cursor.fetchall()
    df_from_db = pd.DataFrame(data_df, columns=['value', 'år', 'lovbruddstype'])



    # connection.commit()
    # cursor.close()
    # connection.close()

    df_from_db.to_csv('fakta_lovbrudd_1.csv')

    return df_from_db

def data_from_fakta2():
    cursor.execute(
        """select sum(f.value), å.år, ag.alder, k.kjønn, s.statistikkvariabel from star_schema.fakta_lovbrudd_2 f
            join star_schema.dim_alder_grupper ag using(alder_id)
            join star_schema.dim_kjønn k using(kjønn_id)
            join star_schema.dim_år å using(år_id)
            join star_schema.dim_statistikkvariabel s using(statistikkvariabel_id)
            group by å.år,ag.alder, k.kjønn, s.statistikkvariabel
            order by å.år asc;""")

    # Get one data from database
    data_df = cursor.fetchall()
    df_from_db = pd.DataFrame(data_df, columns=['value', 'år', 'alder', 'kjønn','statistikkvariabel'])
    # connection.commit()
    # cursor.close()
    # connection.close()

    return df_from_db

df1 = data_from_fakta1()
df2 = data_from_fakta2()

app = dash.Dash(__name__)
app.config.suppress_callback_exceptions = True

option_list = [{'label': b, 'value': b} for b in df1['lovbruddstype'].unique()]
option_year_list = [{'label': b, 'value': b} for b in df1['år'].unique()]
options_sex = [{'label': b, 'value': b} for b in df2['kjønn'].unique()]
options_alder = [{'label': b, 'value': b} for b in df2['alder'].unique()]
options_statistikkvariabel = [{'label': b, 'value': b} for b in df2['statistikkvariabel'].unique()]

oslo_df = pd.read_csv("https://raw.githubusercontent.com/plotly/datasets/master/fips-unemp-16.csv")
import json
from urllib.request import urlopen
with urlopen('https://raw.githubusercontent.com/plotly/datasets/master/geojson-counties-fips.json') as response:
    counties = json.load(response)
    app.layout = html.Div(
        children=[
            dcc.Link('Sosial', href='./VisualizationSosial'),
            html.Div(className='row',
                     children=[

                         html.Div(className='four columns div-user-controls',
                                  children=[
                                      html.H2('Lovbrudd'),
                                      html.Div(
                                          className='div-for-dropdown',
                                          children=[
                                              dcc.Dropdown(id='lovbruddstype', options=option_list,
                                                           multi=True, value=df1['lovbruddstype'][10],
                                                           style={'backgroundColor': '#1E1E1E'},
                                                           className='lovbruddstype'
                                                           ),
                                          ],
                                          style={'color': '#1E1E1E'}),
                                      html.H2('Kjønn'),
                                      html.Div(

                                          className='div-for-dropdown',
                                          children=[

                                              dcc.Dropdown(id='sexs', options=options_sex,
                                                           multi=True, value=df2['kjønn'][3],
                                                           style={'backgroundColor': '#1E1E1E'},
                                                           className='sex'
                                                           ),

                                          ], style={'color': '#1E1E1E'}),

                                      html.H2('Alder'),
                                      html.Div(

                                          className='div-for-dropdown',
                                          children=[

                                              dcc.Dropdown(id='alder', options=options_alder,
                                                           multi=False, value=df2['alder'][3],
                                                           style={'backgroundColor': '#1E1E1E'},
                                                           className='alder'
                                                           ),

                                          ], style={'color': '#1E1E1E'}),

                                      html.H2('Statistikkvariabel'),
                                      html.Div(

                                          className='div-for-dropdown',
                                          children=[

                                              dcc.Dropdown(id='statistikkvariabel', options=options_statistikkvariabel,
                                                           multi=False, value=df2['statistikkvariabel'][3],
                                                           style={'backgroundColor': '#1E1E1E'},
                                                           className='statistikkvariabel'
                                                           )

                                          ]),




                                ]
                             ),
                     html.Div(className='eight columns  bg-grey shadow_layer space_from_bottom' ,
                              children=[
                                  dcc.Graph(id='timeseries', config={'displayModeBar': True}, animate=True)
                              ]),
                     html.Div(className=' columns bg-grey shadow_layer space_from_bottom',
                              children=[
                                  dcc.Graph(id='timeseries1', config={'displayModeBar': True}, animate=True)
                              ]),
                     html.Div(className='bottom_graph  bg-grey shadow_layer',
                              children=[
                                  dcc.Graph(id='timeseries2', config={'displayModeBar': False}, animate=True)
                              ]),
                     html.Div(className='bottom_controller',
                              children=[

                                         dcc.Dropdown(id='lovbruddstype2', options=option_list,
                                                      multi=False, value=df1['lovbruddstype'][10],
                                                      style={'backgroundColor': '#1E1E1E'},
                                                      className='lovbruddstype2'
                                                      ),]),




    ]

)])




@app.callback(Output('timeseries', 'figure'),
              [Input('lovbruddstype', 'value')])
def update_graph(lovbruddstyper):
    trace1 = []
    df_sub = df1.copy()

    for lovbrudd in lovbruddstyper:
        trace1.append(go.Line(x=df_sub[df_sub['lovbruddstype'] == lovbrudd]['år'].sort_values(axis=0, ascending=True).unique(),
                                                 y= df_sub[df_sub['lovbruddstype'] == lovbrudd]['value'],
                                                 mode='lines',
                                                 opacity=0.9,
                                                 name=lovbrudd,
                                                 textposition='bottom center'))


    traces = [trace1]
    data = [val for sublist in traces for val in sublist]
    figure = {'data': data,
              'layout': go.Layout(
                  colorway=['#375CB1', '#FF7400', '#FFF400', '#FF0056',"#5E0DAC", '#FF4F00'],
                  template='plotly_dark',
                  margin={'b': 10},
                  hovermode='x',
                  autosize=True,
                  title={'text': 'Lovbrudd pr. år', 'font': {'color': 'white', 'size':30}, 'x': 0.5},
                  xaxis={'range': [df_sub.lovbruddstype.min(), df_sub.lovbruddstype.max()]},
                  yaxis={'range': [df_sub.lovbruddstype.min(), df_sub.lovbruddstype.max()]}
              ),

              }

    return figure

@app.callback(Output('timeseries1', 'figure'),
              [Input('sexs', 'value'),
               Input('alder', 'value'),
               Input('statistikkvariabel', 'value')])
def lovbrudd_alder_kjønn(sexs, alder, statistikkvariabel):
    trace1 = []
    df_sub = df2.copy()

    df_sub = df_sub[df_sub['alder'] == alder]
    df_sub = df_sub[df_sub['statistikkvariabel'] == statistikkvariabel]

    for sex in sexs:
        trace1.append(go.Line(x=df_sub[df_sub['kjønn'] == sex]['år'].sort_values(axis=0, ascending=True).unique(),
                                      y=df_sub[df_sub['kjønn'] == sex]['value'],
                                      #mode='lines',
                                      opacity=1,
                                      mode='lines+markers',
                                      marker=dict(size=[20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20],
                                                  color=[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]),
                                      name=sex,
                                      textposition='bottom center'))
    traces = [trace1]
    data = [val for sublist in traces for val in sublist]
    figure = {'data': data,
              'layout': go.Layout(
                  colorway=["#5E0DAC", '#FF4F00', '#375CB1', '#FF7400', '#FFF400', '#FF0056'],
                  template='plotly_dark',
                  # paper_bgcolor='rgba(0, 0, 0, 0)',
                  # plot_bgcolor='rgba(0, 0, 0, 0)',
                  margin={'b': 15},
                  hovermode='x',
                  autosize=True,
                  title={'text': 'Statistikkvariabel basert på kjønn og alder', 'font': {'color': 'white', 'size':30}, 'x': 0.5},
                  #xaxis={'range': [df_sub.år.min(), df_sub.år.max()]},
                  yaxis={'range': [df_sub.value.min()*0.9, df_sub.value.max()*1.1]}

              )}
    return figure


@app.callback(Output('timeseries2', 'figure'),
               [Input('lovbruddstype2', 'value')])
def update_graph(lovbruddstype2):
    df_sub = df1.copy()

    #df_sub = df_sub[df_sub['lovbruddstype'] != 'Alle lovbruddstyper']
    df_sub = df_sub[df_sub['lovbruddstype'] == lovbruddstype2]

    # for lovbruddstype in lovbruddstype2:
    #     df_sub = df_sub[df_sub['lovbruddstype'] == lovbruddstype]

    figure = px.bar(data_frame=df_sub, x='år', y='value', text='value', color="lovbruddstype", hover_data=['lovbruddstype', 'value', 'år'],barmode='group',range_x=[df_sub.år.min(),df_sub.år.max()], range_y=[df_sub.value.min(),df_sub.value.max()])
    figure.update_traces(marker_color='rgb(158,202,225)', marker_line_color='rgb(8,48,107)',
                      marker_line_width=1.5, opacity=0.6, textposition='auto', texttemplate='%{text:.2s}')
    figure.update_layout(uniformtext_minsize=8, uniformtext_mode='hide')
    figure.update_xaxes(type='category')
    return figure


PORT = 5713
ADDRESS = '127.0.0.1'

if __name__ == '__main__':
    app.run_server(
        port=PORT,
        host=ADDRESS)