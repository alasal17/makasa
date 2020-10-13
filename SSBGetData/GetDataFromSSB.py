import requests
import pandas as pd
from pyjstat import pyjstat



def main_program():
  lovbrudd_08485()
  lovbrudd_09405()
  lovbrudd_09406()
  lovbrudd_09407()
  lovbrudd_09408()
  lovbrudd_09409()
  lovbrudd_09410()
  lovbrudd_09411()
  lovbrudd_09412()
  lovbrudd_09413()
  lovbrudd_11453()

def create_csv_of_data(url, payload, name_of_csv_file):

  result = requests.post(url, json=payload)
  dataset = pyjstat.Dataset.read(result.text)
  df = dataset.write('dataframe')
  df.head()
  df.tail()
  df.info()

  df.to_csv(f'./SSBGetData/stagingarea/{name_of_csv_file}')

def lovbrudd_08485():
  payload_08485 = {
    "query": [
      {
        "code": "Region",
        "selection": {
          "filter": "item",
          "values": [
            "P01"

          ]
        }
      },
      {
        "code": "LovbruddKrim",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "ContentsCode",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Tid",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      }
    ],
    "response": {
      "format": "json-stat2"
    }
  }
  create_csv_of_data('https://data.ssb.no/api/v0/no/table/08485', payload_08485, 'first_lovbrudd_08485.csv')
  lovbrudd_08485_df = pd.read_csv(r'./SSBGetData/stagingarea/first_lovbrudd_08485.csv')

  lovbrudd_08485_df['lovbruddstype'] = lovbrudd_08485_df['lovbruddstype'].str.replace('¬¬', '')
  lovbrudd_08485_df['lovbruddstype'] = lovbrudd_08485_df['lovbruddstype'].str.replace('¬', '')
  lovbrudd_08485_df['lovbruddstype'] = lovbrudd_08485_df['lovbruddstype'].str.replace("'", '')

  lovbrudd_08485_df = lovbrudd_08485_df.fillna(0)
  del lovbrudd_08485_df['Unnamed: 0']
  lovbrudd_08485_df.to_csv('./SSBGetData/dataset/lovbrudd_08485.csv', encoding='utf-8', sep=',', index=False)

  print("\033[0;32m",'Done ')
  print( "\u001b[35m", 'lovbrudd_08485')

def lovbrudd_09405():
  payload_09405 = {
    "query": [
      {
        "code": "LovbruddKrim",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "PolitiAvgjorelse",
        "selection": {
          "filter": "item",
          "values": [
            "AAA-BZZ",
            "AAA-AZZ",
            "AAZ",
            "BEA",
            "BZH-BZZ"
          ]
        }
      },
      {
        "code": "ContentsCode",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Tid",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      }
    ],
    "response": {
      "format": "json-stat2"
    }
  }

  create_csv_of_data('https://data.ssb.no/api/v0/no/table/09405', payload_09405, 'first_lovbrudd_09405.csv')
  lovbrudd_09405_df = pd.read_csv('./SSBGetData/stagingarea/first_lovbrudd_09405.csv')

  lovbrudd_09405_df['lovbruddstype'] = lovbrudd_09405_df['lovbruddstype'].str.replace('¬¬', '')
  lovbrudd_09405_df['lovbruddstype'] = lovbrudd_09405_df['lovbruddstype'].str.replace('¬', '')
  lovbrudd_09405_df['lovbruddstype'] = lovbrudd_09405_df['lovbruddstype'].str.replace("'", '')

  lovbrudd_09405_df['politiets avgjørelse'] = lovbrudd_09405_df['politiets avgjørelse'].str.replace('¬¬', '')
  lovbrudd_09405_df['politiets avgjørelse'] = lovbrudd_09405_df['politiets avgjørelse'].str.replace('¬', '')
  lovbrudd_09405_df['politiets avgjørelse'] = lovbrudd_09405_df['politiets avgjørelse'].str.replace("'", '')

  lovbrudd_09405_df['statistikkvariabel'] = lovbrudd_09405_df['statistikkvariabel'].str.replace('¬¬', '')
  lovbrudd_09405_df['statistikkvariabel'] = lovbrudd_09405_df['statistikkvariabel'].str.replace('¬', '')
  lovbrudd_09405_df['statistikkvariabel'] = lovbrudd_09405_df['statistikkvariabel'].str.replace("'", '')

  lovbrudd_09405_df = lovbrudd_09405_df.fillna(0)
  del lovbrudd_09405_df['Unnamed: 0']

  lovbrudd_09405_df.to_csv(r'./SSBGetData/dataset/lovbrudd_09405.csv', encoding='utf-8', sep=',', index=False)

  print("\033[0;32m", 'Done ')
  print("\u001b[35m", 'lovbrudd_09405')

def lovbrudd_09406():
  payload_09406 = {
    "query": [
      {
        "code": "LovbruddKrim",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "ContentsCode",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Tid",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      }
    ],
    "response": {
      "format": "json-stat2"
    }
  }

  create_csv_of_data('https://data.ssb.no/api/v0/no/table/09406', payload_09406, 'first_lovbrudd_09406.csv')

  lovbrudd_09406_df = pd.read_csv('./SSBGetData/stagingarea/first_lovbrudd_09406.csv')

  lovbrudd_09406_df['lovbruddstype'] = lovbrudd_09406_df['lovbruddstype'].str.replace('¬¬', '')
  lovbrudd_09406_df['lovbruddstype'] = lovbrudd_09406_df['lovbruddstype'].str.replace('¬', '')
  lovbrudd_09406_df['lovbruddstype'] = lovbrudd_09406_df['lovbruddstype'].str.replace("'", '')

  lovbrudd_09406_df = lovbrudd_09406_df.fillna(0)
  del lovbrudd_09406_df['Unnamed: 0']

  lovbrudd_09406_df.to_csv(r'./SSBGetData/dataset/lovbrudd_09406.csv', encoding='utf-8', sep=',', index=False)

  print("\033[0;32m", 'Done ')
  print("\u001b[35m", 'lovbrudd_09406')

def lovbrudd_09407():
  payload_09407 = {
      "query": [
        {
          "code": "Region",
          "selection": {
            "filter": "item",
            "values": [
              "P01",

            ]
          }
        },
        {
          "code": "PolitiAvgjorelse",
          "selection": {
            "filter": "all",
            "values": [
              "*"
            ]
          }
        },
        {
          "code": "ContentsCode",
          "selection": {
            "filter": "all",
            "values": [
              "*"
            ]
          }
        },
        {
          "code": "Tid",
          "selection": {
            "filter": "all",
            "values": [
              "*"
            ]
          }
        }
      ],
      "response": {
        "format": "json-stat2"
      }
    }
  create_csv_of_data('https://data.ssb.no/api/v0/no/table/09407', payload_09407, 'first_lovbrudd_09407.csv')

  lovbrudd_09407_df = pd.read_csv('./SSBGetData/stagingarea/first_lovbrudd_09407.csv')

  lovbrudd_09407_df['politiets avgjørelse'] = lovbrudd_09407_df['politiets avgjørelse'].str.replace('¬¬', '')
  lovbrudd_09407_df['politiets avgjørelse'] = lovbrudd_09407_df['politiets avgjørelse'].str.replace('¬', '')
  lovbrudd_09407_df['politiets avgjørelse'] = lovbrudd_09407_df['politiets avgjørelse'].str.replace("'", '')

  lovbrudd_09407_df = lovbrudd_09407_df.fillna(0)
  del lovbrudd_09407_df['Unnamed: 0']

  lovbrudd_09407_df.to_csv(r'./SSBGetData/dataset/lovbrudd_09407.csv', encoding='utf-8', sep=',', index=False)
  print("\033[0;32m", 'Done ')
  print("\u001b[35m", 'lovbrudd_09407')

def lovbrudd_09408():
  payload_09408 = {
    "query": [
      {
        "code": "Region",
        "selection": {
          "filter": "item",
          "values": [
            "P01",

          ]
        }
      },
      {
        "code": "LovbruddKrim",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "ContentsCode",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Tid",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      }
    ],
    "response": {
      "format": "json-stat2"
    }
  }
  create_csv_of_data('https://data.ssb.no/api/v0/no/table/09408', payload_09408, 'first_lovbrudd_09408.csv')

  lovbrudd_09408_df = pd.read_csv('./SSBGetData/stagingarea/first_lovbrudd_09408.csv')

  lovbrudd_09408_df['lovbruddstype'] = lovbrudd_09408_df['lovbruddstype'].str.replace('¬¬', '')
  lovbrudd_09408_df['lovbruddstype'] = lovbrudd_09408_df['lovbruddstype'].str.replace('¬', '')
  lovbrudd_09408_df['lovbruddstype'] = lovbrudd_09408_df['lovbruddstype'].str.replace("'", '')

  lovbrudd_09408_df = lovbrudd_09408_df.fillna(0)
  del lovbrudd_09408_df['Unnamed: 0']

  lovbrudd_09408_df.to_csv(r'./SSBGetData/dataset/lovbrudd_09408.csv', encoding='utf-8', sep=',', index=False)

  print("\033[0;32m", 'Done ')
  print("\u001b[35m", 'lovbrudd_09408')

def lovbrudd_09409():
  payload_09409 = {
    "query": [
      {
        "code": "LovbruddKrim",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "AntSiktede",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "ContentsCode",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Tid",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      }
    ],
    "response": {
      "format": "json-stat2"
    }
  }
  create_csv_of_data('https://data.ssb.no/api/v0/no/table/09409', payload_09409, 'first_lovbrudd_09409.csv')

  lovbrudd_09409_df = pd.read_csv('./SSBGetData/stagingarea/first_lovbrudd_09409.csv')

  lovbrudd_09409_df['lovbruddstype'] = lovbrudd_09409_df['lovbruddstype'].str.replace('¬¬', '')
  lovbrudd_09409_df['lovbruddstype'] = lovbrudd_09409_df['lovbruddstype'].str.replace('¬', '')
  lovbrudd_09409_df['lovbruddstype'] = lovbrudd_09409_df['lovbruddstype'].str.replace("'", '')

  lovbrudd_09409_df = lovbrudd_09409_df.fillna(0)
  del lovbrudd_09409_df['Unnamed: 0']

  lovbrudd_09409_df.to_csv(r'./SSBGetData/dataset/lovbrudd_09409.csv', encoding='utf-8', sep=',', index=False)
  print("\033[0;32m", 'Done ')
  print("\u001b[35m", 'lovbrudd_09409')

def lovbrudd_09410():
  payload_09410 = {
    "query": [
      {
        "code": "LovbruddKrim",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Alder",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "ContentsCode",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Tid",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      }
    ],
    "response": {
      "format": "json-stat2"
    }
  }

  create_csv_of_data('https://data.ssb.no/api/v0/no/table/09410', payload_09410, 'first_lovbrudd_09410.csv')

  lovbrud_09410_df = pd.read_csv('./SSBGetData/stagingarea/first_lovbrudd_09410.csv')

  lovbrud_09410_df['lovbruddstype'] = lovbrud_09410_df['lovbruddstype'].str.replace('¬¬', '')
  lovbrud_09410_df['lovbruddstype'] = lovbrud_09410_df['lovbruddstype'].str.replace('¬', '')
  lovbrud_09410_df['lovbruddstype'] = lovbrud_09410_df['lovbruddstype'].str.replace("'", '')

  lovbrud_09410_df = lovbrud_09410_df.fillna(0)
  del lovbrud_09410_df['Unnamed: 0']

  lovbrud_09410_df.to_csv(r'./SSBGetData/dataset/lovbrudd_09410.csv', encoding='utf-8', sep=',', index=False)

  print("\033[0;32m", 'Done ')
  print("\u001b[35m", 'lovbrudd_09410')

def lovbrudd_09411():
  payload_09411 = {
    "query": [
      {
        "code": "LovbruddKrim",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Kjonn",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "ContentsCode",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Tid",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      }
    ],
    "response": {
      "format": "json-stat2"
    }
  }

  create_csv_of_data('https://data.ssb.no/api/v0/no/table/09411', payload_09411, 'first_lovbrudd_09411.csv')

  lovbrud_09411_df = pd.read_csv('./SSBGetData/stagingarea/first_lovbrudd_09411.csv')

  lovbrud_09411_df['lovbruddstype'] = lovbrud_09411_df['lovbruddstype'].str.replace('¬¬', '')
  lovbrud_09411_df['lovbruddstype'] = lovbrud_09411_df['lovbruddstype'].str.replace('¬', '')
  lovbrud_09411_df['lovbruddstype'] = lovbrud_09411_df['lovbruddstype'].str.replace("'", '')

  lovbrud_09411_df = lovbrud_09411_df.fillna(0)
  del lovbrud_09411_df['Unnamed: 0']

  lovbrud_09411_df.to_csv(r'./SSBGetData/dataset/lovbrudd_09411.csv', encoding='utf-8', sep=',', index=False)
  print("\033[0;32m", 'Done ')
  print("\u001b[35m", 'lovbrudd_09411')

def lovbrudd_09412():
  payload_09412 = {
    "query": [
      {
        "code": "AntallLovbr",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Alder",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "ContentsCode",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Tid",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      }
    ],
    "response": {
      "format": "json-stat2"
    }
  }

  create_csv_of_data('https://data.ssb.no/api/v0/no/table/09412', payload_09412, 'first_lovbrudd_09412.csv')
  lovbrudd_09412_df = pd.read_csv('./SSBGetData/stagingarea/first_lovbrudd_09412.csv')

  lovbrudd_09412_df = lovbrudd_09412_df.fillna(0)
  del lovbrudd_09412_df['Unnamed: 0']

  lovbrudd_09412_df.to_csv(r'./SSBGetData/dataset/lovbrudd_09412.csv', encoding='utf-8', sep=',', index=False)

  print("\033[0;32m", 'Done ')
  print("\u001b[35m", 'lovbrudd_09412')

def lovbrudd_09413():
  payload_09413 = {
    "query": [
      {
        "code": "AntallLovbr",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Kjonn",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "ContentsCode",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Tid",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      }
    ],
    "response": {
      "format": "json-stat2"
    }
  }

  create_csv_of_data('https://data.ssb.no/api/v0/no/table/09413', payload_09413, 'first_lovbrudd_09413.csv')

  lovbrudd_09413_df = pd.read_csv('./SSBGetData/stagingarea/first_lovbrudd_09413.csv')

  lovbrudd_09413_df = lovbrudd_09413_df.fillna(0)
  del lovbrudd_09413_df['Unnamed: 0']

  lovbrudd_09413_df.to_csv(r'./SSBGetData/dataset/lovbrudd_09413.csv', encoding='utf-8', sep=',', index=False)

  print("\033[0;32m", 'Done ')
  print("\u001b[35m", 'lovbrudd_09413')

def lovbrudd_11453():
  payload_11453 = {
    "query": [
      {
        "code": "Kjonn",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Alder",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "ContentsCode",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      },
      {
        "code": "Tid",
        "selection": {
          "filter": "all",
          "values": [
            "*"
          ]
        }
      }
    ],
    "response": {
      "format": "json-stat2"
    }
  }

  create_csv_of_data('https://data.ssb.no/api/v0/no/table/11453', payload_11453, 'first_lovbrudd_11453.csv')
  lovbrudd_11453_df = pd.read_csv('./SSBGetData/stagingarea/first_lovbrudd_11453.csv')
  lovbrudd_11453_df = lovbrudd_11453_df.fillna(0)
  del lovbrudd_11453_df['Unnamed: 0']
  lovbrudd_11453_df.to_csv(r'./SSBGetData/dataset/lovbrudd_11453.csv', encoding='utf-8', sep=',', index=False)

  print("\033[0;32m", 'Done ')
  print("\u001b[35m", 'lovbrudd_11453')
