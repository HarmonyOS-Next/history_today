import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig, Method } from '@ohos/axios'

class HttpClient {
  private instance = axios.create({
    baseURL: 'https://api-tanhua-harmony.itheima.net/api/',
    timeout: 20000
  })

  constructor() {
    this.init()
  }

  private init() {
    this.instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
      // TODO
      return config
    }, (err: AxiosError) => {
      // TODO
      return Promise.reject(err)
    })
    this.instance.interceptors.response.use((res: AxiosResponse) => {
      if (res.data?.code === '10000') {
        return res.data?.data
      }
      return Promise.reject(res.data)
    }, (err: AxiosError) => {
      // TODO
      return Promise.reject(err)
    })
  }

  request<Res, Req = null>(config: AxiosRequestConfig<Req>) {
    return this.instance.request<Res, Res, Req>(config)
  }
}

export const httpClient = new HttpClient()