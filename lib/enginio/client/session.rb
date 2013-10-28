require 'json'
require 'httpclient'

module Enginio
  module Client
    class Session

      attr_accessor :default_headers
      attr_reader :api_client, :backend_id

      ##
      # Initialize api client
      #
      # @param [String] backend_id
      # @param [String] api_url
      def initialize(backend_id, api_url = 'https://api.engin.io/v1')
        @backend_id = backend_id
        @api_client = HTTPClient.new
        @default_headers = {'Accept' => 'application/json', 'Content-Type' => 'application/json'}
        @api_url = api_url
      end

      ##
      # Get
      #
      # @param [String] path
      # @param [Hash,NilClass] params
      # @return [Hash]
      def get(path, params = nil, headers = {})
        response = api_client.get(request_uri(path), params, request_headers(headers))
        if response.status == 200
          parse_response(response)
        else
          handle_error_response(response)
        end
      end

      ##
      # Post
      #
      # @param [String] path
      # @param [Object] obj
      # @return [Hash]
      def post(path, obj, headers = {})
        request_headers = request_headers(headers)
        response = api_client.post(request_uri(path), encode_body(obj, request_headers['Content-Type']), request_headers)
        if [200, 201].include?(response.status)
          parse_response(response)
        else
          handle_error_response(response)
        end
      end

      ##
      # Put
      #
      # @param [String] path
      # @param [Object] obj
      # @return [Hash]
      def put(path, obj, headers = {})
        request_headers = request_headers(headers)
        response = api_client.put(request_uri(path), encode_body(obj, request_headers['Content-Type']), request_headers)
        if [200, 201].include?(response.status)
          parse_response(response)
        else
          handle_error_response(response)
        end
      end

      ##
      # Delete
      #
      # @param [String] path
      # @param [Hash,NilClass] params
      # @return [Hash]
      def delete(path, params = nil, headers = {})
        response = api_client.delete(request_uri(path), params, request_headers(headers))
        if response.status == 200
          parse_response(response)
        else
          handle_error_response(response)
        end
      end

      private

      ##
      # Get full request uri
      #
      # @param [String] path
      # @return [String]
      def request_uri(path)
        "#{@api_url}#{path}"
      end

      ##
      # Get request headers
      #
      # @param [Hash] headers
      # @return [Hash]
      def request_headers(headers = {})
        @default_headers.merge({'Enginio-Backend-Id' => @backend_id}).merge(headers)
      end

      ##
      # Encode body based on content type
      #
      # @param [Object] body
      # @param [String] content_type
      def encode_body(body, content_type)
        if content_type == 'application/json'
          dump_json(body)
        else
          body
        end
      end

      ##
      # Parse response
      #
      # @param [HTTP::Message]
      # @return [Object]
      def parse_response(response)
        if response.headers['Content-Type'].include?('application/json')
          parse_json(response.body)
        else
          response.body
        end
      end

      ##
      # Parse json
      #
      # @param [String] json
      # @return [Hash,Object,NilClass]
      def parse_json(json)
        JSON.parse(json) rescue nil
      end

      ##
      # Dump json
      #
      # @param [Object] obj
      # @return [String]
      def dump_json(obj)
        JSON.dump(obj)
      end

      def handle_error_response(response)
        raise Enginio::Client::ErrorMessage.new(response.body)
      end
    end
  end
end
