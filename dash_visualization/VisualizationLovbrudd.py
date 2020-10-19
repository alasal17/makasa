import dash
import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
from dash.dependencies import Input, Output
import plotly.express as px
import plotly.graph_objects as go
import psycopg2
import os


USER_NAME = os.environ['P_USER']
PASS = os.environ['P_PASS']
HOST = os.environ['P_HOST']
PORT = 5432

# Connection
try:
        connection = psycopg2.connect(
            user=USER_NAME,
            password=PASS,
            host=HOST,
            port=PORT,
            database='gp_makasa'
        )

        cursor = connection.cursor()

except Exception as e:
    print(e)


def data_from_fakta1():

    cursor.execute('select l.lovbruddstype, å.år, f.value_lovbrudd from star_schema.fakta_1 f join star_schema.lovbruddstyper l using(lovbrudds_id) join star_schema.år å using(år_id);')

    # Get one data from database
    data_df = cursor.fetchall()
    df_from_db = pd.DataFrame(data_df, columns=['lovbruddstype', 'år', 'value'])

    # connection.commit()
    # cursor.close()
    # connection.close()

    return df_from_db

def data_from_fakta2():
    cursor.execute(
        """select å.år, ag.alder, k.kjønn, s.statistikkvariabel, f.value from star_schema.fakta_2 f
            join star_schema.alder_grupper ag using(alder_id)
            join star_schema.kjønn k using(kjønn_id)
            join star_schema.år å using(år_id)
            join star_schema.statistikkvariabel s using(statistikkvariabel_id);""")

    # Get one data from database
    data_df = cursor.fetchall()
    df_from_db = pd.DataFrame(data_df, columns=['år', 'alder', 'kjønn','statistikkvariabel', 'value'])
    print(df_from_db.columns)
    # connection.commit()
    # cursor.close()
    # connection.close()

    return df_from_db

df1 = data_from_fakta1()
df2 = data_from_fakta2()
#df = pd.read_csv('../SSBGetData/dataset/lovbrudd_09405.csv')
#df['år'] = pd.to_datetime('1996', format='%Y%m%d', errors='ignore')

app = dash.Dash(__name__)


option_list = [{'label': b, 'value': b} for b in df1['lovbruddstype'].unique()]

option_year_list = [{'label': b, 'value': b} for b in df1['år'].unique()]

options_sex = [{'label': b, 'value': b} for b in df2['kjønn'].unique()]
options_alder = [{'label': b, 'value': b} for b in df2['alder'].unique()]
options_statistikkvariabel = [{'label': b, 'value': b} for b in df2['statistikkvariabel'].unique()]

# header = html.Div(html.H1(children='lovbruddstype', className='header'))
# graph = html.Div([dcc.Graph(id='dash_figure')])
# checkbox = html.Div([dcc.Checklist(id='checkbox',options=option_list,value=['Alle lovbruddstyper'])])
# content = [header, graph, checkbox]
# app.layout = html.Div(content, className='ten columns offset-by-one')

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
                                                      multi=True, value=df1['lovbruddstype'][100],
                                                      style={'backgroundColor': '#1E1E1E'},
                                                      className='lovbruddstype'
                                                      ),
                                     ],
                                     style={'color': '#1E1E1E'}),
                                     html.H2('Kjønn'),
                                 html.Div(

                                     className='div-for-dropdown',
                                     children=[

                                         dcc.Dropdown(id='sex', options=options_sex,
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

                                         dcc.Dropdown(id='year', options=option_year_list,
                                                      multi=True, value=df2['år'][3],
                                                      style={'backgroundColor': '#1E1E1E'},
                                                      className='year'
                                                      ),

                                     ], style={'color': '#1E1E1E'})

                                ]
                             ),
                    html.Div(className='eight columns div-for-charts bg-grey',
                             children=[
                                 dcc.Graph(id='timeseries', config={'displayModeBar': True}, animate=True)
                             ]),
                             html.Div(className='eight columns div-for-charts bg-grey',
                             children=[
                                 dcc.Graph(id='timeseries1', config={'displayModeBar': True}, animate=True)
                             ]),
                ])
        ]

)



# Callback for timeseries price
@app.callback(Output('timeseries', 'figure'),
              [Input('lovbruddstype', 'value'),
               Input('year', 'value')])
def update_graph(lovbruddstyper, years):
    trace1 = []
    df_sub = df1
    for lovbruddstype, year in zip(lovbruddstyper, years):
        trace1.append(go.Line(x=df_sub[df_sub['år'] == year]['år'],
                                 y=df_sub[df_sub['lovbruddstype'] == lovbruddstype]['value'].unique(),
                                 mode='lines',
                                 opacity=0.7,
                                 name=lovbruddstype,
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
                  title={'text': 'Lovbruddstype', 'font': {'color': 'white'}, 'x': 0.5},

              ),

              }

    return figure



@app.callback(Output('timeseries1', 'figure'),
              [Input('sex', 'value'),
               Input('alder', 'value')])
def lovbrudd_alder_kjønn(sex, alder):
    trace1 = []
    df_sub = df2

    for sex, alder in zip(sex, alder):
        trace1.append(go.Line(x=df_sub[df_sub['sex'] == sex]['år'],
                              y=df_sub[df_sub['alder'] == alder]['value'],
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
                  title={'text': 'Lovbruddstype', 'font': {'color': 'white'}, 'x': 0.5},

              ),

              }

    return figure


# @app.callback(
#     dash.dependencies.Output('checkbox', 'value'),
#     dash.dependencies.Input('dash_figure', 'figure')
#               )
# def graph_update(lovbruddstype):
#     sub_df = df[['år, lovbruddstype, value']]
#     fig = px.line(data_frame=sub_df, x=sub_df['år'], y=sub_df['value'], color=df[df['lovbruddstype' == lovbruddstype]])
#     fig = fig.show()
#     return fig


if __name__ == '__main__':
    app.run_server(debug=True)
