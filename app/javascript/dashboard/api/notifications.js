/* global axios */
import ApiClient from './ApiClient';

class NotificationsAPI extends ApiClient {
  constructor() {
    super('notifications', { accountScoped: true });
  }

  get(page) {
    return axios.get(`${this.url}?page=${page}`);
  }

  getNotifications(contactId) {
    return axios.get(`${this.url}/${contactId}/notifications`);
  }

  getUnreadCount() {
    return axios.get(`${this.url}/unread_count`);
  }

  read(primaryActorType, primaryActorId) {
    return axios.post(`${this.url}/read_all`, {
      primary_actor_type: primaryActorType,
      primary_actor_id: primaryActorId,
    });
  }

  unRead(id) {
    return axios.post(`${this.url}/${id}/unread`);
  }

  readAll() {
    return axios.post(`${this.url}/read_all`);
  }

  delete(id) {
    return axios.delete(`${this.url}/${id}`);
  }
}

export default new NotificationsAPI();
