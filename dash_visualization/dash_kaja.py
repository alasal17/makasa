import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
from dash.dependencies import Input, Output
import plotly.express as px
import plotly.graph_objects as go
import psycopg2
import os

#%%

USER_NAME = os.environ['P_USER']
PASS = os.environ['P_PASS']
HOST = os.environ['P_HOST']
PORT = 5432
#%%
# Connection

try:
            connection = psycopg2.connect(
                user=P_USER,
                password=PASS,
                host='ds-etl-academy.cgbivchwjzle.eu-west-1.rds.amazonaws.com',
                port=PORT,
                database='gp_makasa'
            )

            cursor = connection.cursor()


except Exception as e:
    print(e)


#%%
def data_from_innvandring():
    cursor.execute("""select då.år, di.kategori, dl.landbakgrunn, sum(fi.antall_innvandrere)  from star_schema.fakta_innvandring fi 
    join star_schema.dim_landbakgrunn dl using(id_landbakgrunn)
    join star_schema.dim_innvandringskategori di using(id_innvandringskategori)
    join star_schema.dim_år då using (år_id)
    where dl.landbakgrunn != 'Innvandrere og norskfødte med innvandrerforeldre'
    group by då.år, di.kategori, dl.landbakgrunn 
    order by då.år ;""")
    data_df = cursor.fetchall()
    df_from_db = pd.DataFrame(data_df, columns=['år', 'kategori', 'landbakgrunn', 'antall'])
    return df_from_db

df = data_from_innvandring()

app = dash.Dash(__name__)
app.config.suppress_callback_exceptions = True

option_list = [{'label': b, 'value': b} for b in df1['lovbruddstype'].unique()]
option_year_list = [{'label': b, 'value': b} for b in df1['år'].unique()]
options_sex = [{'label': b, 'value': b} for b in df2['kjønn'].unique()]
options_alder = [{'label': b, 'value': b} for b in df2['alder'].unique()]
options_statistikkvariabel = [{'label': b, 'value': b} for b in df2['statistikkvariabel'].unique()]


app.layout = html.Div(
    children=[
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
                                                      multi=True, value=df2['alder'][3],
                                                      style={'backgroundColor': '#1E1E1E'},
                                                      className='alder'
                                                      ),

                                     ], style={'color': '#1E1E1E'}),

                                 html.H2('Statistikkvariabel'),
                                 html.Div(

                                     className='div-for-dropdown',
                                     children=[

                                         dcc.Dropdown(id='statistikkvariabel', options=options_statistikkvariabel,
                                                      multi=True, value=df2['statistikkvariabel'][3],
                                                      style={'backgroundColor': '#1E1E1E'},
                                                      className='statistikkvariabel'
                                                      ),

                                     ]),
                                    html.H2('ÅR'),
                                 html.Div(

                                     className='div-for-dropdown',
                                     children=[

                                         dcc.Dropdown(id='years', options=option_year_list,
                                                      multi=True, value=df2['år'][3],
                                                      style={'backgroundColor': '#1E1E1E'},
                                                      className='years'
                                                      ),

                                     ], style={'color': '#1E1E1E'})

                                ]
                             ),
                     html.Div(className='eight columns div-for-charts bg-grey',
                              children=[
                                  dcc.Graph(id='timeseries', config={'displayModeBar': False}, animate=True)
                              ]),
                     html.Div(className='eight columns div-for-charts bg-grey',
                              children=[
                                  dcc.Graph(id='timeseries1', config={'displayModeBar': False}, animate=True)
                              ])
                 ],)

    ]

)


@app.callback(Output('timeseries', 'figure'),
              [Input('lovbruddstype', 'value'),
               Input('years', 'value')])
def update_graph(lovbruddstyper, years):
    trace1 = []
    df_sub = df1
    for lovbrudd in lovbruddstyper:
        trace1.append(go.Line(x=df_sub[df_sub['lovbruddstype'] == lovbrudd]['år'].sort_values(axis=0, ascending=True).unique(),
                                     y= df_sub[df_sub['lovbruddstype'] == lovbrudd]['value'],
                                     mode='x',
                                     #opacity=0.9,
                                     name='lovbruddstype',
                                     textposition='bottom center'))
    traces = [trace1]
    data = [val for sublist in traces for val in sublist]
    figure = {'data': data,
              'layout': go.Layout(
                  colorway=["#5E0DAC", '#FF4F00', '#375CB1', '#FF7400', '#FFF400', '#FF0056'],
                  template='plotly_dark',
                  paper_bgcolor='rgba(0, 0, 0, 0)',
                  plot_bgcolor='rgba(0, 0, 0, 0)',
                  margin={'b': 15},
                  hovermode='x',
                  autosize=True,
                  title={'text': 'Lovbrudd pr. år', 'font': {'color': 'white'}, 'x': 0.5},
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
    df_sub = df2

    for sex, statistikkvariabels, alde in zip(sexs, statistikkvariabel, alder):
        df_sub = df_sub[df_sub['alder'] == alde]
        df_sub = df_sub[df_sub['statistikkvariabel'] == statistikkvariabels]
        trace1.append(go.Line(x=df_sub[df_sub['kjønn'] == sex]['år'].sort_values(axis=0, ascending=True).unique(),
                              y=df_sub[df_sub['kjønn'] == sex]['value'],
                              mode='lines',
                              opacity=0.7,
                              name='kjønn',
                              textposition='bottom center'))
    traces = [trace1]
    data = [val for sublist in traces for val in sublist]
    figure = {'data': data,
              'layout': go.Layout(
                  colorway=["#5E0DAC", '#FF4F00', '#375CB1', '#FF7400', '#FFF400', '#FF0056'],
                  template='plotly_dark',
                  paper_bgcolor='rgba(0, 0, 0, 0)',
                  plot_bgcolor='rgba(0, 0, 0, 0)',
                  margin={'b': 15},
                  hovermode='x',
                  autosize=True,
                  title={'text': 'Statistikkvariabel basert på kjønn og alder', 'font': {'color': 'white'}, 'x': 0.5},
                  xaxis={'range': [df_sub.kjønn.min(), df_sub.kjønn.max()]},
                  yaxis={'range': [df_sub.kjønn.min(), df_sub.kjønn.max()]}

              ),}
    return figure


PORT = 5713
ADDRESS = '127.0.0.1'

if __name__ == '__main__':
    app.run_server(
        port=PORT,
        host=ADDRESS)