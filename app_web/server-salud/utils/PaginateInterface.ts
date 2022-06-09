export default interface Paginate<T>{
    page: number,
    per_page: number,
    data: Array<T>,
    total: number,
    totalPages: number,
    last_page?: number,
}